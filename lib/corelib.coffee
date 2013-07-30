whip = require './whip'

fns =
  lambda: (input, context) ->
    (lambda_args) ->
      lambda_scope = input[1].reduce (acc, x, i) ->
        acc[x.value] = lambda_args[i]
        acc
      , {}

      whip.interpret input[2], new whip.Context(lambda_scope, context)

  let: (input, context) ->
    let_context = input[1].reduce (acc, x) ->
      acc.scope[x[0].value] = whip.interpret x[1], context
      acc
    , new whip.Context({}, context)

    whip.interpret input[2], let_context

module.exports = fns
module.exports['->'] = fns.lambda
