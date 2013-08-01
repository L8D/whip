#!/usr/bin/env node
var args, argv, cmdc, cmdln, code, context, fs, repl, syn, whip;
fs = require('fs');
repl = require('repl');
whip = require('../lib/whip');
syn = require('../lib/syn');

args = require('optimist')
  .usage('Usage: $0 -vlp [filename]')
  .describe('p', 'print parsed code and exit')
  .describe('v', 'print version and exit')
  .describe('h', 'print this help and exit')
  .describe('l', 'use util.inspect for return values instead of syntax converter for REPL');

argv = args.argv;

if (argv.h) {
  args.showHelp();
  process.exit();
}

if (argv.v) {
  console.log("whip " + (require('../package.json').version));
  process.exit();
}

if (argv._.length > 0) {
  code = fs.readFileSync(argv._[0], {
    encoding: 'utf8'
  });
  if (!argv.p) {
    whip.interpret(whip.parse(code));
  } else {
    console.log(whip.parse(code));
  }
} else {
  context = new whip.Context;
  cmdc = 0;
  cmdln = "";
  repl.start({
    prompt: '> ',
    "eval": function(cmd, context, filename, callback) {
      if (cmd !== '(\n)') {
        cmd = cmd.slice(1, -1);
        cmdc += syn.verify(whip.tokenize(cmd));
        if (cmdc < 0) {
          process.exit();
        }
        if (cmdc !== 0) {
          cmdln += cmd;
          return callback(cmdc);
        } else if (!argv.p) {
          cmd = cmdln + cmd;
          cmdln = "";
          if (argv.l) {
            return callback(null, whip.interpret(whip.parse(cmd, context)));
          } else {
            return callback('=> ' + syn.convert(whip.interpret(whip.parse(cmd, context))));
          }
        } else {
          return callback(null, whip.parse(cmd));
        }
      } else {
        return callback(null, (cmdc > 0 ? cmdc : void 0));
      }
    }
  });
}
