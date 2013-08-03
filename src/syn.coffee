# Whip syntax helper lib
# ======================

# ### Object Mapper
# Used for retrieving attribute names of an object.
object_mapper = (obj, fn) -> fn v for v in Object.getOwnPropertyNames obj

# ## Convert
# The `convert` function takes input of any kind
# and attempts to return a string containing the
# whip syntax convention for that type of variable.
#
# For strings it will return the input with surrounding
# double quotes. But if it's length of 1, meaning it's a
# single character, it will return the input with
# surrounding single quotes.
#
# For numbers, it just returns the number casted to a string.
#
# For objects, it will then convert values of it's attributes
# and return it with the proper syntax.
#
# For functions, it justs returns `"(-> ...)"` to prevent
# infinite loops. It will keep this behaivour until
# lazy interpretation is properly implemented.
#
# For null or undefined values, it returns 'null' or 'undefined'.
#
# Otherwise, it will just cast the value to a string and return it.
convert = (input) ->
  r = []
  if input instanceof Array
    r.push (input.map (x) -> convert x).join ' '
    r.unshift '('
    r.push ')'
  else if typeof input is 'string'
    unless input.length == 1
      r.push '"' + input.replace(/\n/g, '\\n') + '"'
    else
      r.push "'" + input.replace(/\n/g, '\\n') + "'"
  else if typeof input is 'function'
    r.push '(-> ...)'
  else if input instanceof Object
    a = []
    object_mapper input, (x) -> a.push "\"#{x}\":#{convert input[x]}"
    r.push a.join ' '
    r.unshift '{'
    r.push '}'
  else if input is null
    r.push 'null'
  else if input is undefined
    r.push 'undefined'
  else
    r.push input
  r.join ''

# ## Verify
# This is a simplistic function that attempts to count
# the amount of `{`s, `(`s, `}`s, and `)`s and determine
# if the expression has been finished.
#
# This is used by the REPL to make sure it doesn't try to
# evaluate your code before you've closed off everything.
verify = (input) ->
  i = 0
  for x in input
    switch x
      when '(', '{' then i++
      when ')', '}' then i--
  i

# Exports
exports.verify = verify
exports.convert = convert
