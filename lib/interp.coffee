special =
  lambda: (input, context) ->
    (lambda_args...) ->
      lambda_scope = input[1].reduce (acc, x, i) ->
        acc[x.value] = lambda_args[i]
        acc

      interpret input[2], new Context(lambda_scope, context)

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

parenthesize = (input, list) ->
  if list is undefined
    parenthesize input, []
  else
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
    {
      type: 'literal'
      value: parseFloat input
    }
  else if input[0] is '"' and input[-1..] is '"'
    {
      type: 'literal'
      value: input.slice 1, -1
    }
  else
    {
      type: 'identifier'
      value: input
    }

parse = (input) ->
  parenthesize tokenize input

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

interpret = (input, context) ->
  if context is undefined
    interpret input, new Context(library)
  else if input instanceof Array
    interpret_list input, context
  else if input.type is 'identifier'
    context.get input.value
  else
    input.value

interpret_list = (input, context) ->
  if input[0].value in special
    special[input[0].value] input, context
  else
    list = input.map (x) -> interpret x, context
    if list[0] instanceof Function
      list[0].apply undefined, list[1..]
    else
      list
