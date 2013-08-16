fs = require 'fs'
# Standard Lib function stack
# ===========================

# These functions are defined here so they can be
# repeated/reiterated multiple times.
fns =
  # ### Add
  # Add first arg and second arg.
  add: (x) -> x[0] + x[1]

  # ### Subtract
  # Subtruct second arg from first arg.
  sub: (x) -> x[0] - x[1]

  # ### Multiply
  # Multiply first arg by second arg.
  mult: (x) -> x[0] * x[1]

  # ### Divide
  # Divide second arg by first arg.
  div: (x) -> x[0] / x[1]

  # ### Modulo
  # Modulo second arg by first arg.
  mod: (x) -> x[0] % x[1]

  # ### Print
  # Print first arg with `console.log`.
  # Returns printed string.
  print: (x) -> console.log x[0]; x[0]

  # ### Prints
  # Same as `print` but uses `process.stdout.write`
  # to prevent newline.
  prints: (x) -> process.stdout.write x[0]; x[0]

  # ### At
  # Find element of the index of first arg in second arg.
  # Very similar to `arg1[arg2]` style of obtaining
  # elements in arrays of other languages.
  #
  # This function works for strings, lists, and dictionaries.
  at: (x) -> x[1][x[0]]

  # ### Either
  # Logical 'or' of first 2 args.
  # This does C-Style evaluation in which if the first
  # arg eval's to **true**, then it immediately returns that.
  # Otherwise, it just returns the next arg, for that to be evaluated
  # by something else.
  either: (x) -> if x[0] then x[0] else x[1]

  # ### Both
  # Logical 'and' of first 2 args.
  # This does C-Style evaluation in reverse of that to `either`
  # where if the first arg eval's to **false** it immediately returns that.
  # Otherwise, it just returns the next arg, for that yo be evaluated
  # by something else.
  both: (x) -> if x[0] then x[1] else x[0]

  # ### Equal
  # This uses javascript `===` operator on the first
  # two args. If returns the evaluation.
  equal: (x) -> x[0] is x[1]

  # ### Not
  # Logical 'not' of first arg.
  # Reverses first arg from true to false and vice versa.
  not: (x) -> not x[0]

  # ### Append
  # Returns second arg with first arg concatenated to it.
  # Exa: `(<< 4 (1 2 3)) ; => (1 2 3 4)`
  append: (x) -> x[1].concat x[0]

  # ### Length
  # Returns the result of the .length method.
  #
  # This currently works well on strings and list, but not dicts.
  length: (x) -> x[0].length

  # ### Greater
  # Uses JavaScript's `>` operator to determine the greater arg.
  greater: (x) -> x[0] > x[1]

  # ### Lesser
  # Uses JavaScript's `<` operator to determine the lesser arg.
  lesser: (x) -> x[0] < x[1]

  # ### Range
  # Returns list of numbers from the range of the first arg to the second arg.
  #
  #     (.. 1 10) ; => (1 2 3 4 5 6 7 8 9 10)
  range: (x) -> [x[0]..x[1]]

  # ### Slice
  # Returns sliced list of first arg from second and on args.
  slice: (x) -> x[0].slice.call(x[0], x[1..])

library =
  # ### Lure
  # Lure is a global variable that equals the process's argv.
  #
  #     (lure) ; => ("node" "/usr/bin/whip")
  lure: process.argv

  # ### True
  # represents true value.
  true: true

  # ### False
  # Represents false value.
  false: false

  # ## Haskellish functions

  # First element of a list.
  head: (a) -> a[0][0]
  # All elements of a list except for the first.
  tail: (a) -> a[0][1..]
  # Last element of a list.
  last: (a) -> a[0].slice(-1)[0]
  # Opposite of `tail`.
  init: (a) -> a[0][0..-2]
  # All elements of a list up to first arg.
  take: (x) -> x[1][0..x[0]]
  # Opposite of `take`.
  drop: (x) -> x[1][(x[1].length - x[0])..-1]
  # Minimum value in a list.
  min:  (a) -> Math.min.apply null, a[0]
  # Maximum value in a list.
  max:  (a) -> Math.max.apply null, a[0]
  # Check if an element exists in a list.
  elem: (x) -> x[0] in x[1]
  # Reverse order of a list.
  reverse: (a) -> a[0].reverse()
  # Check if even.
  even: (x) -> x[0] % 2 is 0
  # Check if odd.
  odd:  (x) -> x[0] % 2 isnt 0
  # Split string into list by whitespace.
  words: (x) -> x[0].split /\s+/
  # Join list into string.
  unwords: (a) -> a[0].join ' '
  # Self explanatory...
  pred:  (x) -> --x[0]
  succ:  (x) -> ++x[0]

  # ### Reduce
  # Takes two args, a function/lambda, and a list.
  # It uses JavaScript's built-in `Array.prototype.reduce` method
  # to call on the first arg.
  #
  # The lambda should take two args and return one value.
  #
  #     (reduce + (1 2 3 4))
  #
  # is the same as
  #
  #     (+ (+ (+ 1 2) 3) 4)
  reduce: (a) -> a[1].reduce (p, x, i) -> a[0] [p, x]

  # ### Map
  # Takes two args, a function/lambda, and a list.
  # It uses JavaScript's built-in `Array.prototype.map` method
  # to call on the first arg.
  #
  # The lambda function should take one arg, and return one value.
  # It will be called for each elem in the list, and maps the same index
  # in the resulting list of the result of calling the function with
  # the elem as the first arg.
  map: (a) -> a[1].map (x) -> a[0] [x]

  # ## Word function repeats
  add:     fns.add
  sub:     fns.sub
  mult:    fns.mult
  div:     fns.div
  mod:     fns.mod

  print:   fns.print
  prints:  fns.prints
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

  # ## Shortcut function repeats
  # Lispy stuff.
  '+':  fns.add
  '-':  fns.sub
  '*':  fns.mult
  '/':  fns.div
  '%':  fns.mod

  '.':  fns.print
  '._': fns.prints
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

  # JSON lib
  # --------

  # ### Harvest
  # The harvest function takes a string contianing JSON
  # and returns a dictionary containing equivalent values
  # for Whip.
  #
  # Bascially it's a `JSON.parse` wrapper.
  harvest: (x) -> JSON.parse x[0]

  # ### Seed
  # The seed function takes a dictionary as an argument
  # and returns equivalent JSON string.
  #
  # Basically it's a `JSON.stringify` wrapper.
  seed: (x) -> JSON.stringify x[0]

  # ### Cultivate
  # Like `seed` function, but it optionally takes a second
  # arg, a boolean, to determine to use either tabs or spaces
  # for JSON prettification.
  # By default, two spaces are used.
  cultivate: (x) -> JSON.stringify x[0], null, x[1] ? '  '

  # File IO
  # -------

  # ### Puke
  # The puke function takes a filename and a string and writes
  # that string to the file.
  puke: (x) -> fs.writeFileSync x[0], x[1], (err) -> throw err if err

  # ### Spit
  # The spit function takes a filename and a string and
  # appends that string to the file.
  spit: (x) -> fs.appendFileSync x[0], x[1], (err) -> throw err if err

  # ### Slurp
  # The slurp function takes a filename and optional encoding
  # and returns a string of the contents of the entire file.
  #
  # It uses UTF-8 encoding by default.
  slurp: (x) ->
    fs.readFileSync x[0], {encoding: x[1] ? 'utf8'}, (err) -> throw err if err

module.exports = library
