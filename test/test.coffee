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

describe 'Whip', ->
  describe 'parser', ->
    it 'should lex a single atom', ->
      'a'.should.eql w.parse('a').value

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
        ['hi', "mary", "rose"].should.eql w.interpret w.parse '("hi" "mary" "rose")'

      it 'should return list of numbers', ->
        [1, 2, 3].should.eql w.interpret w.parse '(1 2 3)'

      it 'should return list of numbers in strings as strings', ->
        ["1", "2", "3"].should.eql w.interpret w.parse '("1" "2" "3")'

    describe 'atoms', ->
      it 'should return string atom', ->
        'a'.should.eql w.interpret w.parse '"a"'


      it 'should return string with space atom', ->
         'a b'.should.eql w.interpret w.parse '"a b"'


      it 'should return string with opening paren', ->
        '(a'.should.eql w.interpret w.parse '"(a"'


      it 'should return string with closing paren', ->
        ')a'.should.eql w.interpret w.parse '")a"'


      it 'should return string with parens', ->
        '(a)'.should.eql w.interpret w.parse '"(a)"'


      it 'should return number atom', ->
        123.should.eql w.interpret w.parse '123'



    describe 'invocation', ->
      it 'should run print on an int', ->
        1.should.eql w.interpret w.parse '(print 1)'


      it 'should return first element of list', ->
        1.should.eql w.interpret w.parse '(head (1 2 3))'


      it 'should return rest of list', ->
        [2, 3].should.eql w.interpret w.parse '(tail (1 2 3))'



    describe 'lambdas', ->
      it 'should return correct result when invoke lambda w no params', ->
        [2].should.eql w.interpret w.parse '((lambda (tail (1 2))))'


      it 'should return correct result for lambda that takes and returns arg', ->
        1.should.eql w.interpret w.parse '((lambda (x) x) 1)'


      it 'should return correct result for lambda that returns list of vars', ->
        [1, 2].should.eql w.interpret w.parse '((lambda (x y) (x y)) 1 2)'


      it 'should get correct result for lambda that returns list of lits + vars', ->
        [0, 1, 2].should.eql w.interpret w.parse '((lambda (x y) (0 x y)) 1 2)'


      it 'should return correct result when invoke lambda w params', ->
        1.should.eql w.interpret w.parse '((lambda (x) (head (x))) 1)'

    describe 'let', ->
      it 'should eval inner expression w names bound', ->
        [1, 2].should.eql w.interpret w.parse '(let ((x 1) (y 2)) (x y))'


      it 'should not expose parallel bindings to each other', ->
        # Expecting undefined for y to be consistent with normal
        # identifier resolution in littleLisp.
        [1, undefined].should.eql w.interpret w.parse '(let ((x 1) (y x)) (x y))'

      it 'should accept empty binding list', ->
        42.should.eql w.interpret w.parse '(let () 42)'

    describe 'if', ->
      it 'should choose the right branch', ->
        42.should.eql w.interpret w.parse '(if true 42 4711)'
        4711.should.eql w.interpret w.parse '(if false 42 4711)'
