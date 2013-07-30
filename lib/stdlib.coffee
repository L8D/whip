fns =
  print: (x, c) ->
    console.log y for y in x
    x
  at:     (x) -> x[1][x[0] - 1]
  if:     (x) -> if x[0] then x[1] else x[2]
  either: (x) -> if x[0] then x[0] else x[1]
  both:   (x) -> if x[0] then x[1] else x[0]
  equal:  (x) -> x[0] is x[1]
  not:    (x) -> not x[0]

library =
  lure:   process.argv
  true:   true
  false:  false
  reduce: (a) -> a[1].reduce (p, x, i) -> a[0] [p, x]
  map:    (a) -> a[1].map (x) -> a[0] x

  print:  fns.print
  at:     fns.at
  if:     fns.if
  either: fns.either
  both:   fns.both
  equal:  fns.equal
  not:    fns.not

  # Lispy stuff and shortcuts
  '+': (x) -> x[0] + x[1]
  '-': (x) -> x[0] - x[1]
  '*': (x) -> x[0] * x[1]
  '/': (x) -> x[0] / x[1]

  '.': fns.print
  ':': fns.at
  '?': fns.if
  '^': fns.either
  '&': fns.both
  '=': fns.equal
  '!': fns.not

module.exports = library
