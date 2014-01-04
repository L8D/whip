var tokenize = function (input) {
  return input.split('"').map(function (x, i) {
    if (i % 2 === 0) {
      return x.replace(/\(/g, ' ( ')
              .replace(/\)/g, ' ) ')
              .replace(/-([^\d\s\(\)])/g, function (_, x) {
                return x.toUpperCase();
              });
    } else {
      return x.replace(/ /g, '\\s');
    }
  }).join('"')
    .trim()
    .split(/\s+/)
    .map(function (x) {
      return x.replace(/\\s/g, ' ');
    });
};

var n, parenthesize = function (input, list) {
  list = list || [];

  var token = input.shift();
  switch (token) {
    case undefined:
    case '':
    case ')':
      return list;

    case '(':
      list.push(parenthesize(input));
      break;

    default:
      // this is where the magic number parsing happens
      // if +token becomes NaN then the token is used as
      // the symbol(which still hasn't been parsed as a string),
      // otherwise it then uses +token as the number.
      //
      // So... 1, 1.0, 1., .1, 01, 0x1, 1e0, -1, +1,  ...
      // Also, as a bug, +'Infinity' is parsed into Infinity
      // are all parsed as numbers
      //
      // See: http://www.ecma-international.org/ecma-262/5.1/#sec-9.3.1
      list.push(isNaN(n = +token) ? token : n);
      break;
  }

  return parenthesize(input, list);
};

// parse = parenthesize . tokenize
var parse = module.exports = function (input) {
  return parenthesize(tokenize(input));
};
