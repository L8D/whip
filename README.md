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

Vairable Notation
-----------------

### Number
``` haskell
1    -- notational value of 1 but literal value of 1.0
1.0  -- notational value of 1(because it is a .0) but literal value of 1.0
3.14 -- notational and literal value of 3.14
```

Standard convention is that you should not use a `.0` if you are not intending a float/double style variable.

### Char
``` haskell
'a' -- notational value of 'a' but literal value of 97(ascii)

-- syntax for casting number to char is a prefixed grave symbol
`97 -- notational value of 'a'
```

Single quotes are for single chars, where as double quotes are for strings.

```
'a' -- value of 'a'
"a" -- value of ['a']
```

### Bool
```
true  -- notational value of true but literal value of 1
false -- notational value of false but literal value of 0

-- syntax for casting number to bool is a prefixed double-grave symbol
``1 -- notational value of true but literal value of 1
```
