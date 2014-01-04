should  = require 'should'
{parse} = require '../lib'

describe 'parse', ->
  it 'should lex an empty list in absence of expression', ->
    parse('').should.eql []

  it 'should seperate tokens into symbols', ->
    parse('foo bar baz').should.eql ['foo', 'bar', 'baz']


  it 'should lex s-expressions into arrays', ->
    parse('(1 2 3)').should.eql [[1, 2, 3]]

  it 'should lex nested s-expressions', ->
    parse('1 (2 (3 (4) 5) 6) 7').should.eql [1, [2, [3, [4], 5], 6], 7]

  it 'should convert hyphens to upper case letters', ->
    parse('foo-bar-baz').should.eql ['fooBarBaz']

  describe 'atoms', ->
    it 'should parse strings', ->
      parse('"This is a cherry old string!"')
        .should.eql ['This is a cherry old string!']

    it 'should parse numbers', ->
      parse('1 1.0 1. .1 0x1 01').should.eql [1, 1, 1, .1, 1, 1]
