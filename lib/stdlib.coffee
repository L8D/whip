fns =
  print:   (x) -> console.log x[0]; x[0]
  at:      (x) -> x[1][x[0]]
  if:      (x) -> if x[0] then x[1] else x[2]
  either:  (x) -> if x[0] then x[0] else x[1]
  both:    (x) -> if x[0] then x[1] else x[0]
  equal:   (x) -> x[0] is x[1]
  not:     (x) -> not x[0]
  append:  (x) -> x[1].push x[0]; x[1]
  length:  (x) -> x[0].length
  greater: (x) -> x[0] > x[1]
  lesser:  (x) -> x[0] < x[1]
  range:   (x) -> [x[0]..x[1]]
  slice:   (x) -> x[0].slice.call(x[0], x[1..])

library =
  lure:    process.argv
  true:    true
  false:   false

  # Haskellish stuff
  head:    (a) -> a[0][0]
  tail:    (a) -> a[0][1..]
  last:    (a) -> a[0].slice(-1)[0]
  init:    (a) -> a[0][0..-1]
  take:    (x) -> x[1][0..x[0]]
  drop:    (x) -> x[1][(x[1].length - x[0])..-1]
  min:     (a) -> a[0].reduce (x, y) -> if x < y then x else y
  max:     (a) -> a[0].reduce (x, y) -> if x > y then x else y
  elem:    (x) -> x[0] in x[1]
  reverse: (a) -> a[0].reverse()
  even:    (x) -> x[0] % 2 is 0
  odd:     (x) -> x[0] % 2 isnt 0
  words:   (x) -> x[0].split ' '
  unwords: (a) -> a[0].join ' '
  pred:    (x) -> --x[0]
  succ:    (x) -> ++x[0]

  reduce:  (a) -> a[1].reduce (p, x, i) -> a[0] [p, x]
  map:     (a) -> a[1].map (x) -> a[0] [x]

  print:   fns.print
  at:      fns.at
  if:      fns.if
  either:  fns.either
  both:    fns.both
  equal:   fns.equal
  not:     fns.not
  append:  fns.append
  length:  fns.length
  greater: fns.greater
  lesser:  fns.lesser
  range:   fns.range
  slice:   fns.slice

  # Lispy stuff and shortcuts
  '+':  (x) -> x[0] + x[1]
  '-':  (x) -> x[0] - x[1]
  '*':  (x) -> x[0] * x[1]
  '/':  (x) -> x[0] / x[1]
  '%':  (x) -> x[0] % x[1]

  '.':  fns.print
  '@':  fns.at
  '?':  fns.if
  '^':  fns.either
  '&':  fns.both
  '=':  fns.equal
  '!':  fns.not
  '<<': fns.append
  '_':  fns.length
  '>':  fns.greater
  '<':  fns.lesser
  '..': fns.range
  '\\': fns.slice

module.exports = library
