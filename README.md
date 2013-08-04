Whip
====
[![NPM version](https://badge.fury.io/js/whip.png)](http://badge.fury.io/js/whip) [![Build Status](https://travis-ci.org/L8D/whip.png?branch=master)](https://travis-ci.org/L8D/whip)

Haskellish LISP dialect.

Install
-------
You'll need to install node first.
``` bash
$ npm install whip -g
```
If you want to get the most up-to-date build, then clone this directory and build from source.
``` bash
$ git clone https://github.com/L8D/whip.git
# ...
$ cd whip
$ cake build
:)
$ sudo npm install -g
```

Usage
-----
Running the `whip` command with no arguments will start the REPL interpreter. Otherwise use `whip <filename>` on `.whp` files to execute them.
``` bash
$ whip -h
Usage: whip [option] [filename]

Options:
  -p  print parsed code and exit
  -v  print version and exit
  -h  print this help and exit
$ whip
> (print "Hello, world!")
Hello, world!
=> "Hello, world!"
>
```

Documentation
-------------
Official documentation at [https://L8D.github.io/whip](https://L8D.github.io/whip) with [source files](https://L8D.github.io/Whip/docs/whip).
For a whirlwind tour, see [this](http://learnxinyminutes.com/docs/whip/) great learnXinYminutes.com post.
