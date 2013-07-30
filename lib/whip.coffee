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

  set: (ident, value) ->
    if @parnet is undefined
      @scope[ident] = value
    else
      @parent.set ident, value

class Var
  constructor: (type, value) ->
    @type = type
    @value = value
    return

tokenize = (input) ->
  o = input.split('"')
    .map((x, i) ->
      if i % 2 is 0 # not in string
        x.replace(/\(/g, ' ( ')
          .replace(/\)/g, ' ) ')
          .replace(/\{/g, ' { ')
          .replace(/\}/g, ' } ')
          .replace(/:/g, ' : ')
      else
        x.replace /\s/g, "!%!"
    )
    .join('"')
    .trim()
    .split(/\s+/)
    .map (x) -> x.replace(/!%!/g, " ")
  i = 1
  for t in o[1..]
    switch t
      when '('
        i++
        if i is 1
          o.unshift '('
          o.push ')'
          break
      when ')' then i--
  o

objectize = (input, object = {}, key = true) ->
  token = input.shift()
  if token is '}'
    categorize object
  else if token is ':'
    objectize input, object, false
  else if key
    object[categorize(token).value] = objectize input, object
    objectize input, object, true
  else
    if token is '('
      parenthesize token
    else
      categorize token


parenthesize = (input, list = []) ->
  token = input.shift()
  switch token
    when undefined
      list.pop()
    when '('
      list.push parenthesize input
      parenthesize input, list
    when ')'
      list
    when '{'
      list.push objectize input
      parenthesize input, list
    else
      parenthesize input, list.concat categorize token

categorize = (input) ->
  if not isNaN parseFloat input
    new Var 'literal', parseFloat input
  else if input[0] is '"' and input[-1..] is '"'
    new Var 'literal', input.slice(1, -1)
  else if input instanceof Object
    new Var 'dict', input
  else
    new Var 'identifier', input

parse = (input) ->
  parenthesize tokenize input

object_mapper = (obj, fn) -> fn v for v in Object.getOwnPropertyNames obj

interpret = (input, context=(new Context library)) ->
  if input instanceof Array
    interpret_list input, context
  else if input.type is 'identifier'
    context.get input.value
  else if input.type is 'dict'
    object_mapper input.value, (x) -> input.value[x] = interpret input.value[x]
    input.value
  else
    input.value

interpret_list = (input, context) ->
  if input[0].value of special
    special[input[0].value](input, context)
  else
    list = input.map (x) -> interpret(x, context)
    if list[0] instanceof Function
      list[0] list[1..]
    else
      list

exports.interpret = interpret
exports.parse = parse
exports.Context = Context
exports.Var = Var
