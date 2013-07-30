object_mapper = (obj, fn) -> fn v for v in Object.getOwnPropertyNames obj

convert = (input) ->
  r = []
  switch true
    when input instanceof Array
      r.push (input.map (x) -> convert x).join ' '
      r.unshift '('
      r.push ')'
    when typeof input is 'string'
      r.push '"' + input + '"'
    when input instanceof Object
      object_mapper input, (x) -> r.push "\"#{x}\":#{convert input[x]}"
      r.unshift '{'
      r.push '}'
    else
      r.push input
  r.join ''

exports.convert = convert
