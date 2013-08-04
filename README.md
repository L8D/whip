Whip - The Haskellish LISP
==========================

Install
-------
You'll need to install node first.
``` bash
$ npm install whip -g
```
If you want to get the most up-to-date build, then clone this directory and build from source.
``` bash
$ git clone https://github.com/L8D/Whip.git
# ...
$ cd Whip
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
Official documentation at [https://L8D.github.io/Whip](https://L8D.github.io/Whip) with [source files](https://L8D.github.io/Whip/docs/whip).
See [`doc/whip.lisp`](https://L8D.github.io/whip/docs/whip.lisp)
