object_mapper = (obj, fn) -> fn v for v in Object.getOwnPropertyNames obj

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

verify = (input) ->
  i = 0
  for x in input
    switch x
      when '(', '{' then i++
      when ')', '}' then i--
  i

exports.verify = verify
exports.convert = convert
