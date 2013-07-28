Whip - Haskell-flavoured LISPish language thingy
================================================

Variable Types
--------------

### Atoms
Atoms are the smallest variable types.

#### Number
Numbers are the most basic of variables. In programming terms, they a doubles. If a number is an integer(not decimals) they are commonly represented without the '.0' on the end.

#### Char
Chars(aka. Characters) are very similar to C-style char ints. They are commonly represented by the ASCII-value they correlate with. They hold a value between 0 and 255. If a number not between 0 and 255 is casted to a char, it's value will be modulo wrapped from 255(`%= 255`).

#### Bool
Bools(aka. Booleans) are very similar to C-style booleans. They are commonly represented by either `true` or `false`. They hold a value of either 0 or 1. Same as a char, if a number that is not between 0 and 1 is casted to a bool, it will be module wrapped.

#### Null
Nulls(aka. nil, void, undefined) are value types given to variables that have absolutely no value.

### Sets
Sets are ways of containing, sorting, and orginizing multiple values.

#### Dict
Dicts(aka. Dictionaries) are very similar to JavaScript objects, or Python dictionaries. They hold multiple values of either atoms or other sets. For each value in the dict, there is a key associated to it.

#### List
Lists(aka. Arrays) are very similar to JavaScript arrays in the case that they are simply dictionaries that only use numbers for their keys. They are commonly represented by it's corresponding array notation, instead of just a dict using keys as numbers.

#### String
Strings are very similar to Haskell strings, in the case that they are simply arrays consisting of only chars. They are commonly represented by it's corresponding string notation, instead of an actual array of chars.

Value Notation
-----------------

### Atoms

#### Number
``` ruby
1    # notational value of 1 but literal value of 1.0
1.0  # notational value of 1(because it is a .0) but literal value of 1.0
3.14 # notational and literal value of 3.14
```

Standard convention is that you should not use a `.0` if you are not intending a float/double style variable.

#### Char
``` ruby
'a' # notational value of 'a' but literal value of 97(ascii)

# syntax for casting number to char is a prefixed grave symbol
`97 # notational value of 'a'
```

Single quotes are for single chars, where as double quotes are for strings.

``` ruby
'a' # value of 'a'
"a" # value of ['a']
```

#### Bool
``` ruby
true  # notational value of true but literal value of 1
false # notational value of false but literal value of 0

# syntax for casting number to bool is a prefixed double-grave symbol
``1 # notational value of true but literal value of 1
```

### Sets
Sets have two types of notation: declaration and retrieval.

#### Dict
Declaration is similar to python and JavaScript.
``` ruby
{"key":"value" "foo":1}
```

Retrival is the same for every set.
``` ruby
# To get the value of "foo"
{"key":"value"}["key"] # represents "value"
```

#### List
Lists can be declared by simply making a dict that only uses numbers as it's keys. The conventional way of making an array automatically assign a number key of the position.
``` ruby
{1:"something" 2:"foo" 3:"var"} # the unconventional way of making an array.
["something" "foo" "var"] # the conventional way of making an array

["element 1" "element 2" "element 3"][2] # "element 2"
```

#### String
Strings are very simple and as seen previously.
``` ruby
{1:'a' 2:'b' 3:'c'}
# is the same as:
['a' 'b' 'c']
# which is the same as:
"abc"

# and retrieval works too
"abc"[2] # 'b'
```

Functions(Lambdas) and Variables
-----------------------

### Lambdas
Another type of variable is a is lambda. The syntax for a lambda uses the `def` function which(when defining a lambda) takes two arguements: arg set, value. The arg set is just an array of undefined variables that uses '()'s instead of '[]'s. The value is just code that eventually returns a value, but that code gets re-avaluated everytime the lambda is called. A lambda looks like:
``` ruby
(def (x y) x + y) # first argument is considered 'x' and the second is 'y', then it returns the value of x + y

```

### Variables
Variables are a very powerful thing to have. The syntax for defining a variable uses the `def` function which(when defining a variable) takes two arguments: name, value. The name is a string that represents what the variables name will be, and the value will be the permanently stored value of it.
``` ruby
(def "foo" 10)
```
Now later in your code, whenever you reference `foo` it will represent 10. Like:
``` ruby
(add foo 5) # returns 10 + 5, 15
```

### Functions
Functions are basically variables containing lambdas. Syntax is as straight forward as:
``` ruby
(def "add" (x y) x + y)
```

Semantics
---------

### Conditionals
The `if` function is pretty standard. It takes three args, the first argument is evaluated to a bool, if the bool is true, it returns the 2nd arg, if the bool is false it returns the 3rd arg or nothing if there isn't a 3rd arg.
Example:
``` ruby
(if true "true is true" "true is false") # returns "true is true"
```

### Booleans
Because the developer is very lasy and didn't want to implement something better, the `both`, `either`, `not` and `equal` functions are similar to `&&`, `||`, `!` and `!=`.
``` ruby
(either false (both (not false) true)) # true
```

### Loops

##### It's _called_ recursion
The `self` variable represents the current lambda definition. Also the `parent` variable represents the parent lambda, and the `parentof` function returns the parent of the first argument.

So...
``` ruby
(equal (parentof self) parent)
```

### Streams
Streams are represented by a number, and allow for reading and writing to them.
To create duplex stream which is strictly for in-program use, use the `canal` function like so:
``` ruby
(def mystream canal) # mystream is now some random number
```
To write to the stream, use the `pump` function like so:
``` ruby
(pump mystream "foo")
```
To read from a stream, use the `scoop` function like so:
``` ruby
(scoop mystream) # returns "foo"
```
And you can optionally close streams with the `clog` function like so:
``` ruby
(clog mystream)
(pump mysream "foo") # raises error
```

### File IO

#### Writing
Write a string to a file:
``` ruby
(puke "foobar.txt" "foo")
```
Append a string to a file:
``` ruby
(spit "foobar.txt" "bar")
```

#### Reading
Read entire file to string:
``` ruby
(slurp "foobar.txt") # returns "foobar"
```
Read x amount of chars from file(third argument can represent the current position in the file):
``` ruby
(sip "foobar.txt" 3) # returns "foo"
(sip "foobar.txt" 3 3) # returns "bar"
```

#### Streams
Additionally, you can use streams for file reading and writing with the `well` function like so:
``` ruby
(def myfile (well "foobar.txt"))
(scoop myfile) # returns "foobar"
(pump myfile "\nfoobar on line 2")
(clog myfile) # closes and writes file
```

### Enviroments
Let's say you need enviroment variables or maybe command line arguments? Well the `enviro` and `lure` variables are at your service.

#### Enviroment variables
The `enviro` variable is a dictionary of the current shell enviroment variables.
``` ruby
(enviro["SHELL"]) # /bin/bash or something of the sort...
```

####  Command line arguments
The lure variable is an array of the command line arguments given at runtime. The array starts with the source file regarless of whether it was run like `whip script.whp` or `./script.whp`. **Remember**: lists start at 1.
``` ruby
# ./script.whp foo
(lure[1]) # "./script.whp"
(lure[2]) # "foo"
```

#### Standard output, input, and error
Although you can just use the `/dev/std*` files the same, the `stdout`, `stdin`, and `stderror` are addresses for file reading and writing. **But** you should use them if you want platform independant code(They can be changed depending on your OS/Enviroment).

A simple unix-like concatenation program.
``` ruby
(puke stdout (slurp stdin))
```

#### External resources/libraries
Something not in the standard library? That's fine. Just use the `require` or `import` functions.

The `require` function imports an imported library for confining to a variable, whereas the `import` function will import a library into the namespace(use import sparingly to avoid flooding). For example:
``` ruby
(def "JSON" (require "json"))
(JSON::parse "{\"name\":\"bob\", \"age\":20") # {"name":"bob" "age":20}
(import "json")
(parse "{\"amount\":10}") # {"amount":10"}
```

### Network IO

#### Sockets
Sockets are just like duplex streams, but with networks and all that. To create a socket, use the `plug` function like so:
``` ruby
(def mysock (plug "www.google.com" 80)) # mysock is now some random number
```
Sending stuff through the socket with stream pumps and scoops.
``` ruby
(pump mysock "GET / HTTP/1.1\r\nHost: www.google.com\r\n\r\n")
(scoop mysock) # returns string of the entire HTTP query with the HTML and everything.
(clog mysock)
```

#### HTTP
Luckily, there is an HTTP function set that automates the whole thingy above.
The `tour` function takes a URI string as it's first argument and returns a string of the recieved HTTP file:
``` ruby
(tour "http://jsonip.com")
# returns "{"ip":"255.255.255.255",about":"/about","Pro!":"http://getjsonip.com"}"
```
<small>I chose to use jsonip.com since it had an index page that is really simple.</small>
