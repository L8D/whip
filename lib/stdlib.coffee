library =
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

module.exports = library
