#!/usr/bin/env coffee
# This is heavily inspired by the Little Lisp Interpreter by Mary Rose Cook
fs = require 'fs'
repl = require 'repl'
whip = require '../lib/whip'
syn  = require '../lib/syn'
args = require('optimist')
  .usage('Usage: $0 -vlp [filename]')
  .describe('p', 'print parsed code and exit')
  .describe('v', 'print version and exit')
  .describe('h', 'print this help and exit')
  .describe('l', 'use util.inspect for return values instead of syntax converter for REPL')

argv = args.argv

if argv.h
  args.showHelp()
  process.exit()

if argv.v
  console.log "whip #{require('../package.json').version}"
  process.exit()

if argv._.length > 0
  code = fs.readFileSync(argv._[0], {encoding: 'utf8'})
  unless argv.p
    whip.interpret whip.parse code
  else
    console.log whip.parse code
else
  context = new whip.Context
  cmdc = 0
  cmdln = ""
  repl.start
    prompt: '> '
    eval: (cmd, context, filename, callback) ->
      unless cmd is '(\n)'
        cmd = cmd[1..-2]
        cmdc += syn.verify whip.tokenize cmd

        process.exit() if cmdc < 0

        if cmdc isnt 0
          cmdln += cmd
          callback cmdc

        else unless argv.p
          cmd = cmdln + cmd
          cmdln = ""
          if argv.l
            callback null, whip.interpret whip.parse cmd, context
          else
            callback '=> ' + syn.convert whip.interpret whip.parse cmd, context

        else
          callback null, whip.parse cmd
      else
        callback null, (cmdc if cmdc > 0)
