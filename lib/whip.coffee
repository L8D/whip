library = require './stdlib'
special = require './corelib'

class Context
  constructor: (scope, parent) ->
    @scope = scope
    @parent = parent
    return

  get: (ident) ->
    if ident of @scope
      @scope[ident]
    else if @parent isnt undefined
      @parent.get ident

class Var
  constructor: (type, value) ->
    @type = type
    @value = value
    return

tokenize = (input) ->
  input.split('"')
    .map((x, i) ->
      if i % 2 is 0 # not in string
        x.replace(/\(/g, ' ( ')
          .replace /\)/g, ' ) '
      else
        x.replace /\s/g, "!%!"
    )
    .join('"')
    .trim()
    .split(/\s+/)
    .map (x) -> x.replace(/!%!/g, " ")

parenthesize = (input, list=[]) ->
  token = input.shift()
  switch token
    when undefined
      list.pop()
    when '('
      list.push parenthesize input, []
      parenthesize input, list
    when ')'
      list
    else
      parenthesize input, list.concat categorize token

categorize = (input) ->
  if not isNaN parseFloat input
    new Var 'literal', parseFloat input
  else if input[0] is '"' and input[-1..] is '"'
    new Var 'literal', input.slice(1, -1)
  else
    new Var 'identifier', input

parse = (input) ->
  parenthesize tokenize input

interpret = (input, context=(new Context library)) ->
  if input instanceof Array
    interpret_list input, context
  else if input.type is 'identifier'
    context.get input.value
  else
    input.value

interpret_list = (input, context) ->
  if input[0].value of special
    special[input[0].value](input, context)
  else
    list = input.map (x) -> interpret(x, context)
    if list[0] instanceof Function
      list[0].apply(library, [list[1..]])
    else
      list

exports.interpret = interpret
exports.parse = parse
exports.Context = Context
exports.Var = Var
