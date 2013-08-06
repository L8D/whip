w = require '../lib/whip'
should = require 'should'
iss = (input, type) ->
  Object::toString.call(input) is "[object #{type}]"


# takes an AST and replaces type annotated nodes with raw values
unan = (input) ->
  if iss input, 'Array'
    if input[0] is undefined
      []
    else if iss input[0], 'Array'
      [unan input[0]].concat unan input[1..]
    else
      unan(input[0]).concat unan input[1..]
  else
    [input.value]

ip = (input) -> w.interpret w.parse input

describe 'Whip', ->
  describe 'parser', ->
    it 'should lex a single atom', ->
      'a'.should.equal w.parse('a').value

    it 'should lex an atom in a list', ->
      [].should.eql unan w.parse '()'

    it 'should lex multi atom list', ->
      ['hi', 'you'].should.eql unan w.parse '(hi you)'

    it 'should lex list containing list', ->
      [['x']].should.eql unan w.parse '((x))'

    it 'should lex list containing list and atoms', ->
      ['x', ['x']].should.eql unan w.parse '(x (x))'

    it 'should lex list containing list and atoms and seperators', ->
      ['x', ['y'], 'z'].should.eql unan w.parse '(x (y) z)'

    it 'should lex list containing multiple list', ->
      ['x', ['y'], ['a', 'b', 'c']].should.eql unan w.parse '(x (y) (a b c))'

    describe 'atoms', ->
      it 'should parse out numbers', ->
        [1, ['a', 2]].should.eql unan w.parse '(1 (a 2))'

  describe 'interpreter', ->
    describe 'lists', ->
      it 'should return list of strings', ->
         ip('("hi" "mary" "rose")').should.eql ['hi', "mary", "rose"]

      it 'should return list of numbers', ->
         ip('(1 2 3)').should.eql [1, 2, 3]

      it 'should return list of numbers in strings as strings', ->
         ip('("1" "2" "3")').should.eql ["1", "2", "3"]

    describe 'atoms', ->
      it 'should return string atom', ->
         ip('"a"').should.equal 'a'

      it 'should return string with space atom', ->
          ip('"a b"').should.equal 'a b'

      it 'should return string with opening paren', ->
         ip('"(a"').should.equal '(a'

      it 'should return string with closing paren', ->
         ip('")a"').should.equal ')a'

      it 'should return string with parens', ->
         ip('"(a)"').should.equal '(a)'

      it 'should return number atom', ->
         ip('123').should.equal 123

    describe 'invocation', ->
      it 'should run print on an int', ->
         ip('(print 1)').should.equal 1

      it 'should return first element of list', ->
         ip('(head (1 2 3))').should.equal 1

      it 'should return rest of list', ->
         ip('(tail (1 2 3))').should.eql [2, 3]



    describe 'lambdas', ->
      it 'should return correct result when invoke lambda w no params', ->
         ip('((lambda (tail (1 2))))').should.eql [2]

      it 'should return correct result for lambda that takes and returns arg', ->
         ip('((lambda (x) x) 1)').should.equal 1

      it 'should return correct result for lambda that returns list of vars', ->
         ip('((lambda (x y) (x y)) 1 2)').should.eql [1, 2]

      it 'should get correct result for lambda that returns list of lits + vars', ->
         ip('((lambda (x y) (0 x y)) 1 2)').should.eql [0, 1, 2]

      it 'should return correct result when invoke lambda w params', ->
         ip('((lambda (x) (head (x))) 1)').should.equal 1

    describe 'let', ->
      it 'should eval inner expression w names bound', ->
         ip('(let ((x 1) (y 2)) (x y))').should.eql [1, 2]

      it 'should not expose parallel bindings to each other', ->
        # Expecting undefined for y to be consistent with normal
        # identifier resolution in littleLisp.
         ip('(let ((x 1) (y x)) (x y))').should.eql [1, undefined]

      it 'should accept empty binding list', ->
         ip('(let () 42)').should.equal 42

    describe 'if', ->
      it 'should choose the right branch', ->
         ip('(if true 42 4711)').should.equal 42
         ip('(if false 42 4711)').should.equal 4711

    describe 'dictionaries', ->
      it 'should generate dictionary with keys and values', ->
        ip('{key:42 "other key":"value"}').should.eql {"key":42, "other key":"value"}

describe 'stdlib', ->
  describe 'arithmetic', ->
    it 'should add two float lits', ->
       ip('(+ 2.5 2.5)').should.equal 5

    it 'should subtract two number lits', ->
       ip('(- 10 5)').should.equal 5

    it 'should multiply two number lits', ->
       ip('(* 5 5)').should.equal 25

    it 'should divide two number lits', ->
       ip('(/ 25 5)').should.equal 5

    it 'should modulo two number lits', ->
       ip('(% 19 7)').should.equal 5

    it 'should compare greatness of two number lits', ->
      ip('(> 5 1)').should.be.true
      ip('(< 5 1)').should.be.false

    describe 'type coercion', ->
      it 'should concatenate two strings', ->
         ip('(+ "foo " "bar")').should.equal 'foo bar'

      it 'should generate javascript-ruled string', ->
         ip('(+ 5 "5")').should.equal '55'

  describe 'boolean expressions', ->
    it 'should evaluate not false to true', ->
      ip('(! false)').should.be.true

    it 'should evaluate true and false to false', ->
      ip('(& true false)').should.not.be.true
      ip('(& false true)').should.not.be.true

    it 'should evaluate true or false to true', ->
      ip('(^ true false)').should.be.true
      ip('(^ false true)').should.be.true

    describe 'equalities', ->
      it 'should compare numbers as equal', ->
        ip('(= 42 42)').should.be.true

      it 'should compare strings as equal', ->
        ip('(= "foo" "foo")').should.be.true

      # TODO: Add support for comparing lists
      it 'should not compare lists as equal', ->
        ip('(= (1) (1))').should.not.be.true

  describe 'indexing', ->
    it 'should find value of list from index', ->
      ip('(@ 1 (1 2 3))').should.equal 2

    it 'should find attribute of dict from index', ->
      ip('(@ "key1" {"key0":"foo" "key1":42 key2:false})').should.equal 42

    it 'should find letter of string from index', ->
      ip('(@ 3 "foobar")').should.equal 'b'

    describe 'lengths', ->
      it 'should get length of string', ->
        ip('(_ "foobar")').should.equal 6

      it 'should get length of list', ->
        ip('(_ (1 2 3))').should.equal 3

      it 'should not any get length of dict', ->
        should.not.exist ip('(_ {0:0 1:1})')

    describe 'slicing', ->
      it 'should slice range list', ->
        ip('(\\ (.. 1 100) -5)').should.eql [96, 97, 98, 99, 100]

  # TODO: Haskell functions, map, and reduce functions

describe 'JSON lib', ->
  describe 'harvest function', ->
    it 'should parse JSON strings and numbers', ->
      ip('(harvest "{\\"key\\":\\"value\\", \\"key2\\":42}")')
        .should.eql key: 'value', key2: 42
    it 'should parse JSON containing null', ->
      should.not.exist ip('(harvest "{\\"foo\\": null}")').foo

  describe 'seed function', ->
    it 'should generate proper JSON', ->
      ip('(seed {key:"value" key2:42})').should.equal '{"key":"value","key2":42}'

    it 'should not generate keys with undefined value', ->
      ip('(seed {foo:undefined})').should.equal '{}'

  describe 'cultivate function', ->
    it 'should generate pretty JSON without specifier', ->
      ip('(cultivate {key:"value"})').should.equal '{\n  "key": "value"\n}'

    it 'should generate pretty JSON with custom specifier', ->
      ip('(cultivate {key:"value"} "\\t")').should.equal '{\n\t"key": "value"\n}'
