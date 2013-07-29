exports.library =
  first: (x) -> x[0]
  rest:  (x) -> x[1..]
  print: (x, c) ->
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
  reduce: (a) ->
    a[1].reduce (p, x, i) ->
      a[0] [p, x]
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
  ':': (x) ->
    x[1][x[0]]
