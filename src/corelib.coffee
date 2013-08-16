whip = require './whip'

# # CoreLib Function Stack
fns =
  # ### Lambda
  # The corelib lambda function takes 1-2 arguements. If it gets 2 arguments, it
  # will return a function(*lambda*) that will bind the list of raw
  # identifiers(in the first argument) to the arguments given of that
  # lambda(inside the return arg's scope). Otherwise, if there is one argument,
  # then it will skip the binding process.
  #
  # The resulting code looks like this:
  #
  #     (lambda (x) (+ x 10))
  lambda: (input, context) ->
    (lambda_args) ->
      unless input.length is 2
        lambda_scope = input[1].reduce (acc, x, i) ->
          acc[x.value] = lambda_args[i]
          acc
        , {}
      else
        lambda_scope = {}

      whip.interpret input[input.length - 1],
        new whip.Context(lambda_scope, context)

  # ### Let
  # The corelib let function takes two arguments.
  # The first is a list of lists of [raw_ident, value] syntax.
  # The second is a return value which will have a modified scope for the
  # arguments.
  #
  # I'm not sure why I kept it, but the resulting code looks like:
  #
  #     (let ((x 10) (y 5)) (+ x y)) ; = 10 + 5 => 15
  let: (input, context) ->
    let_context = input[1].reduce (acc, x) ->
      acc.scope[x[0].value] = whip.interpret x[1], context
      acc
    , new whip.Context({}, context)

    whip.interpret input[2], let_context

  # ### Def
  # The def function is a much more usable version of `let`.
  # It takes two args, an ident and a value.
  # It then uses the `Context::set` method for setting the value
  # (the second arg) to the global namespace.
  #
  # This allows for your code to be maintained in the same context,
  # at the same indent, and allow future code or libraries to use it.
  #
  # Looks like:
  #
  #     (def x 10)
  #     (x) ; => 10
  def: (input, context) ->
    v = whip.interpret input[2]
    context.set input[1].value, v
    v

  # ### If
  # Returns interpreted second arg if first arg evaluates to true.
  # Otherwise it returns the interpreted third argument.
  if: (input, context) ->
    if input[0]
      whip.interpret input[1], context
    else
      whip.interpret input[2], context if input[2]?

module.exports = fns
# Lambda shortcut of `->`
module.exports['->'] = fns.lambda
