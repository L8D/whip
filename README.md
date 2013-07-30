Whip: A Haskellish LISP
=======================

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
$ echo '(print "Hello, world!")' > hello.whp
$ whip hello.whp
Hello, world!
```

Documentation
-------------
See [`doc/whip.lisp`](doc/whip.lisp)
