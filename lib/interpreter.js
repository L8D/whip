var lib = require('./library');

var spec = {
  if: function(i, c) {
    return interpret(i[1], c) ?
      interpret(i[2], c) :
      interpret(i[3], c);
  }
};

function Context(scope, parent) {
  this.scope = scope;
  this.parent = parent;
}

Context.prototype.get = function(ident) {
  if (ident in this.scope) {
    return this.scope[ident];
  } else if (this.parent) {
    return this.parent.get(ident);
  }
};

var interpretL = function(xs, c) {
  if (xs[0] && spec[xs[0]]) {
    return spec[xs[0]](xs, c);
  }

  var ys = xs.map(function(x) { return interpret(x, c); });
  if (ys[0] instanceof Function) {
    return ys[0].apply(undefined, ys.slice(1));
  }

  return ys;
};

var interpret = module.exports = function(i, c) {
  if (!c) c = new Context(lib);

  if (i instanceof Array) {
    return interpretL(i, c);
  } else if (typeof i === 'string' && i[0] !== '"') {
    return c.get(i);
  } else {
    return i;
  }
};
