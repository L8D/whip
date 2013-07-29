exports.library =
  first: (x) -> x[0]
  rest:  (x) -> x[1..]
  print: (x) ->
    console.log y for y in x
    x
  true: true
  false: false
  if: (x) ->
    if x[0]
      x[1]
    else
      x[2]
  either: (x) ->
    if x[0]
      x[1]
    else
      x[0]
  both: (x) ->
    if x[0]
      x[1]
    else
      x[0]
  equal: (x) ->
    if x[0] is x[1]
      true
    else
      false
  not: (x) ->
    not x[0]
  wat: (x...) ->
    console.log x
  reduce: (a) ->
    func = a[0]
    args = a[1]
    args.reduce (p, x, i) ->
      func [p, x]
  # Lispy stuff
  '+': (x) ->
    x[0] + x[1]
  '-': (x) ->
    x[0] - x[1]
  '*': (x) ->
    x[0] * x[1]
  '/': (x) ->
    x[0] / x[1]
  '=': (x) ->
    if x[0] is x[1] then true else false

exports.special =
  lambda: (input, context) ->
    (lambda_args...) ->
      lambda_scope = input[1].reduce (acc, x, i) ->
        acc[x.value] = lambda_args[i]
        acc

      interpret input[2], new Context(lambda_scope, context)
  def: (input, context) ->
    context.scope[input[1].value] = input[2].value
