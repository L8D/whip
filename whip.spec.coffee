assert = require 'assert'
w = require './lib/whip'

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

## Whip core
# Whip parsing

# should lex a single atom
assert w.parse('a').value is 'a'

# should lex an atom in a list
console.log
assert (unan w.parse '()').is []

# should lex multi-atom list
assert (unan w.parse '(x y)').is ['x', 'y']

# should lex listception
assert (unan w.parse '((x))').is [['x']]

# should lex listception
assert (unan w.parse '(x (x))').is ['x', ['x']]

# should lex listception
assert (unan w.parse '(x y (x))').is ['x', 'y', ['x']]

# should lex listception
assert (unan w.parse '(x (y) z)').is ['x', ['y'], 'z']

# should lex listception
assert (unan w.parse '(x (y) (a b c))').is ['x', ['y'], ['a', 'b', 'c']]

# should lex numbers and strings differently
assert (unan w.parse '(1 (a 2))').is [1, ['a', 2]]

# Whip interpretation

# should return list of strings
assert (w.interpret w.parse '("foo" "bar" "tests")').is ['foo', 'bar', 'tests']
