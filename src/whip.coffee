# Whip interpreter
# ===============

library = require './stdlib'
special = require './corelib'

# ### Context class
# The `Context` class is used for maintaining context's and scopes
# of defined variables.
#
# It's constructor takes two args, and binds them to the scope
# and parent attributes. The scope should be an object with keys
# representing variable names, the parent should be another instance
# of a `Context` to maintain scopes. The parent though isn't required
# to properly create and use the `Context` class.
class Context
  constructor: (@scope, @parent) ->

  # #### Get
  # Takes an identifier string and returns the value from the scope.
  # However if it can't find that value, it attempts to call `get` on
  # the parent context and return that result.
  get: (ident) ->
    if ident of @scope
      @scope[ident]
    else if @parent?
      @parent.get ident

  # #### Set
  # Takes and identifier and value.
  # If there is no parent context, it maps the value to the identifier
  # in the scope. If there is a parent, it calls `set` on that instead.
  #
  # This method is only used by the core library function `def`.
  set: (ident, value) ->
    if @parent is undefined
      @scope[ident] = value
    else
      @parent.set ident, value

# ### Var class
# This class is simply used to better keep track of variables
# and for the future if we need to easily edit stuff.
class Var
  constructor: (@type, @value) ->

# ## Tokenize
# The `tokenize` function takes input and returns an array
# of tokens representing each instruction part.
#
# It also attempts to add surrounding parens if it detects that there
# are multiple forms in the global scope.
tokenize = (input) ->
  o = input
    .replace(/\\"/g, "!dquote!")
    .replace(/\s+' '\s+/g, "'!space!'")
    .split(/"/)
    .map((x, i) ->
      if i % 2 is 0 # not in string
        x
          .replace(/;.*(\n|\z)/, '') # comment
          .replace(/\(/g, ' ( ')
          .replace(/\)/g, ' ) ')
          .replace(/\{/g, ' { ')
          .replace(/\}/g, ' } ')
          .replace(/:/g, ' : ')
      else
        x.replace /\s/g, "!space!"
    )
    .join('"')
    .trim()
    .split(/\s+/)
    .map (x) -> x
      .replace(/!space!/g, " ")
      .replace(/!dquote!/g, '\\"')
      .replace(/!squote!/g, "\\'")
  i = 1
  for t in o[1..]
    switch t
      when '('
        i++
        if i is 1
          o.unshift '('
          o.push ')'
          break
      when ')' then i--
  o

# ## Objectize
# Returns an object deciphered from output of `tokenize`.
#
# Whip's dicitonary syntax is `key`, `:`, `value` and then
# whitespace between each definition.
objectize = (input, object = {}, key = true) ->
  token = input.shift()
  if token is '}'
    categorize object
  else if key
    object[categorize(token).value] = objectize input, object, false
    objectize input, object, true
  else
    if token is '('
      parenthesize token
    else
      categorize token


# ## Parenthesize
# Returns an array deciphered from output of `tokenize`.
parenthesize = (input, list = []) ->
  token = input.shift()
  switch token
    when undefined
      list.pop()
    when '('
      list.push parenthesize input
      parenthesize input, list
    when ')'
      list
    when '{'
      list.push objectize input
      parenthesize input, list
    else
      parenthesize input, list.concat categorize token

# ## Categorize
# Returns `Var` instance from output of `tokenize`.
# Primarily used by `parenthesize` and `objectize`.
categorize = (input) ->
  if not isNaN parseFloat input
    new Var 'literal', parseFloat input
  else if input[0] is '"' and input[-1..] is '"'
    new Var 'literal', eval input
  else if input[0] is "'" and input[-1..] is "'"
    new Var 'literal', input[1..-2]
  else if input instanceof Object
    new Var 'dict', input
  else
    new Var 'identifier', input

# ## Parse
# Wrapper for returned parsed output of input.
parse = (input) ->
  parenthesize tokenize input

object_mapper = (obj, fn) -> fn v for v in Object.getOwnPropertyNames obj

# ## Interpret
# Returns value based on parsed information.
interpret = (input, context=(new Context library)) ->
  if input instanceof Array
    interpret_list input, context
  else if input.type is 'identifier'
    context.get input.value
  else if input.type is 'dict'
    object_mapper input.value, (x) -> input.value[x] = interpret input.value[x]
    input.value
  else
    input.value

# ## Interpret List
# I'm tired...
interpret_list = (input, context) ->
  return if input.length is 0
  if input[0].value of special
    special[input[0].value](input, context)
  else
    list = input.map (x) -> interpret(x, context)
    if list[0] instanceof Function
      list[0] list[1..]
    else
      list

exports.interpret = interpret
exports.parse = parse
exports.tokenize = tokenize
exports.Context = Context
exports.Var = Var
