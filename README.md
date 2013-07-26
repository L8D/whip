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

### Sets
Sets are ways of containing, sorting, and orginizing multiple values.

#### Dict
Dicts(aka. Dictionaries) are very similar to JavaScript objects, or Python dictionaries. They hold multiple values of either atoms or other sets. For each value in the dict, there is a key associated to it.

#### List
Lists(aka. Arrays) are very similar to JavaScript arrays in the case that they are simply dictionaries that only use numbers for their keys. They are commonly represented by it's corresponding array notation, instead of just a dict using keys as numbers.

#### Tuple
Tuples are very similar to Haskell tuples in the case that they have different variable type depending on the order and type of values it contains.

`TODO: Add more stuff about Tuples`

#### String
Strings are very similar to Haskell strings, in the case that they are simply arrays consisting of only chars. They are commonly represented by it's corresponding string notation, instead of an actual array of chars.

Value Notation
-----------------

### Atoms

#### Number
``` python
1    # notational value of 1 but literal value of 1.0
1.0  # notational value of 1(because it is a .0) but literal value of 1.0
3.14 # notational and literal value of 3.14
```

Standard convention is that you should not use a `.0` if you are not intending a float/double style variable.

#### Char
``` python
'a' # notational value of 'a' but literal value of 97(ascii)

# syntax for casting number to char is a prefixed grave symbol
`97 # notational value of 'a'
```

Single quotes are for single chars, where as double quotes are for strings.

``` python
'a' # value of 'a'
"a" # value of ['a']
```

#### Bool
``` python
true  # notational value of true but literal value of 1
false # notational value of false but literal value of 0

# syntax for casting number to bool is a prefixed double-grave symbol
``1 # notational value of true but literal value of 1
```

### Sets
Sets have two types of notation: declaration and retrieval.

#### Dict
Declaration is similar to python and JavaScript.
``` python
{"key":"value" "foo":1}
```

Retrival is the same for every set.
``` python
# To get the value of "foo"
{"key":"value"}["key"] # represents "value"
```

#### List
Lists can be declared by simply making a dict that only uses numbers as it's keys. The conventional way of making an array automatically assign a number key of the position.
``` python
{1:"something" 2:"foo" 3:"var"} # the unconventional way of making an array.
["something" "foo" "var"] # the conventional way of making an array

["element 1" "element 2" "element 3"][2] # "element 2"
```

#### String
Strings are very simple and as seen previously.
``` python
{1:'a' 2:'b' 3:'c'}
# is the same as:
['a' 'b' 'c']
# which is the same as:
"abc"

# and retrieval works too
"abc"[2] # 'b'
```

#### Tuple
Tuples are their own type of set. Though you can cast an array to a tuple. Additionally, the syntax for a tuple require a comma in between to differentiate it from a function call or something.
``` python
('a', 5)
# syntax for casting array, object, or string to tuple is a prefixed grave symbol; like for chars and bools
`['a' 5] # ('a', 5)
```

Functions and Variables
-----------------------

### Functions
Another type of variable is a function. Though in your code, a function will represent another type of variable.  To define a function, you use the function `def`. The `def` function takes 3 arguments like so: string, tuple bundle(tuple without commas), value. Where the string is the name of the function, the tuple is a set of args, and the 'value' is any value that will be evaluated.

A function that takes to args and adds them together:
```
#    name
#      |  arguments
#      |      | returned value
#      |      |       |
(def "add" (n1 n2) n1 + n2)
```
Now later in our code, when I use the "add" function like so.
```
(add 5 5) # represents 10
```

### Variables
Variables are a very powerful thing to have. To define a variable, you define a function without any arguments.
```
(def "foo" 10)
```
Now later in your code, whenever you reference `foo` it will represent 10. Like:
```
(add 5 foo) # represents the value of 5 + 10 which is 15
```
