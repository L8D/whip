fns =
  print: (x, c) ->
    console.log y for y in x
    x
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
  at: (x) ->
    x[1][x[0] - 1]

library =
  lure: process.argv
  true: true
  false: false
  print: fns.print
  at: fns.at
  if: fns.if
  either: fns.either
  both: fns.both
  equal: fns.equal
  not: fns.not
  reduce: (a) ->
    a[1].reduce (p, x, i) ->
      a[0] [p, x]
  map: (a) ->
    a[1].map (x) ->
      a[0] x
  # Lispy stuff
  '+': (x) ->
    x[0] + x[1]
  '-': (x) ->
    x[0] - x[1]
  '*': (x) ->
    x[0] * x[1]
  '/': (x) ->
    x[0] / x[1]

  '.': fns.print
  ':': fns.at
  '?': fns.if
  '=': fns.equal
  '!': fns.not
  '&': fns.both
  '^': fns.either

exports.library = library
