assert = require 'assert'
w = require '../lib/whip'

is_a = (input, type) ->
  Object::toString.call(input) is "[object #{type}]"

# take an AST and replaces type annotated nodes with raw values
unan = (input) ->
  if is_a input, 'Array'
    if input[0] is undefined
      []
    else if is_a input[0], 'Array'
      [unan input[0]].concat unan input[1..]
    else
      unan(input[0]).concat unan input[1..]
  else
    [input.value]

# for comparing arrays
Array::is = (o) ->
  return true if @ is o
  return false if @length isnt o.length
  for i in [0..@length]
    if @[i] instanceof Array
      return true if @[i].is o[i]
    else
      return false if @[i] isnt o[i]
  true

ip = (code) -> w.interpret w.parse code
up = (code) -> unan w.parse code


## Whip core
# Whip parsing

# should lex a single atom
assert w.parse('a').value is 'a'

# should lex an atom in a list
assert (up '()').is []

# should lex multi-atom list
assert (up '(x y)').is ['x', 'y']

# should lex listception
assert (up '((x))').is [['x']]

# should lex listception
assert (up '(x (x))').is ['x', ['x']]

# should lex listception
assert (up '(x y (x))').is ['x', 'y', ['x']]

# should lex listception
assert (up '(x (y) z)').is ['x', ['y'], 'z']

# should lex listception
assert (up '(x (y) (a b c))').is ['x', ['y'], ['a', 'b', 'c']]

# should lex numbers and strings differently
assert (up '(1 (a 2))').is [1, ['a', 2]]

# Whip interpretation
# lists

# should return list of strings
assert (ip '("foo" "bar" "tests")').is ['foo', 'bar', 'tests']

# should return list of numbers
assert (ip '(1 2 3)').is [1, 2, 3]

# should return list of numbers in strings as strings
assert (ip '("1" "2" "3")').is ['1', '2', '3']

# atoms

# should return string atom
assert (ip '"a"') is 'a'

# should return string atom with space
assert (ip '"a b"') is 'a b'

# should return string with opening paren
assert (ip '")a"') is ')a'

# should return string with closing paren
assert (ip '"(a"') is '(a'

# should return string with both parens
assert (ip '"(a)"') is '(a)'

# should return simple number atom
assert (ip '123') is 123

# should return floating number atom
assert (ip '3.14') is 3.14

# lambdas

# should return correct result when invoke lambda with no params
assert (ip '((lambda () 1))') is 1

# should return correct result for lambda that takes and returns arg(not inside a list)
assert (ip '((lambda (x) x) 1)') is 1

# should return correct result for lambda that takes and returns list of vars
assert (ip '((lambda (x y) (x y)) 1 2)').is [1, 2]

# should return correct result for lambda that returns list of literals and vars
assert (ip '((lambda (x y) (0 x y)) 1 2)').is [0, 1, 2]

# let

# should eval inner expression w names bound
assert (ip '(let ((x 1) (y 2)) (x y))').is [1, 2]

# should not expose parallel bindings to each other
assert (ip '(let ((x 1) (y x)) (x y))').is [1, undefined]

# should accept empty binding list
assert (ip '(let () 42)') is 42

# if

# should choose the right branch
assert (ip '(if true 42 420)')
assert (ip '(if false 42 420)') is 420

# comparatives

# should return true
# TODO: Expand this sonofabitch
assert ip '(greater 10 5)'
assert ip '(lesser 5 10)'
assert ip '(equal 10 10)'
assert ip '(not false)'
assert ip('((-> (x) (<< "bar" x)) ("foo"))').is ['foo', 'bar']

# should return length
assert ip('(length (1 2))') is 2
