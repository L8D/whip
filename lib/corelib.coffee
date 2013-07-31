whip = require './whip'

fns =
  lambda: (input, context) ->
    (lambda_args) ->
      unless input.length is 2
        lambda_scope = input[1].reduce (acc, x, i) ->
          acc[x.value] = lambda_args[i]
          acc
        , {}
      else
        lambda_scope = {}

      whip.interpret input[input.length - 1], new whip.Context(lambda_scope, context)

  let: (input, context) ->
    let_context = input[1].reduce (acc, x) ->
      acc.scope[x[0].value] = whip.interpret x[1], context
      acc
    , new whip.Context({}, context)

    whip.interpret input[2], let_context

  def: (input, context) ->
    v = whip.interpret input[2]
    context.set input[1].value, v
    v

module.exports = fns
module.exports['->'] = fns.lambda
