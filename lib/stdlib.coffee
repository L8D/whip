library =
  first: (x) -> x[0]
  rest: (x) -> x[1..]
  print: (x) ->
    console.log x
    x

module.exports = library
