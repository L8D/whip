Whip - The Haskellish LISP
==========================

Install
-------
You'll need to install node first.
``` bash
# Global
$ npm install whip -g
# Local
$ npm install whip -l
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
See [`doc/whip.lisp`](https://github.com/L8D/Whip/blob/master/doc/whip.lisp)
