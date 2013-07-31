; Comments are like LISP. Semi-solons...

; Majority of first-level statements are inside "forms"
; which are just things inside parens separated by whitespace
not_in_form
(in_form)

; Whip has one number type (which is a 64-bit IEEE 754 double, from JavaScript).
3 ; => 3
1.5 ; => 1.5

; Functions are called if they are the first element in a form
(called_function args)

; Majority of operations are done with functions
; All the basic arihmetic is pretty straight forward
(+ 1 1) ; => 2
(- 2 1) ; => 1
(* 1 2) ; => 2
(/ 2 1) ; => 2
; even modulo
(% 9 4) ; => 1
; JavaScript-style uneven division.
(/ 5 2) ; => 2.5

; Nesting forms words as you expect.
(* 2 (+ 1 3)) ; => 8

; There's a boolean type.
true
false

; String are created with ".
"Hello, world"

; Single chars are created with '.
'a'

; Negation uses the 'not' function.
(not true) ; => false
(not false) ; => true

; But the majority of non-haskell functions have shortcuts
; not's shortcut is a '!'.
(! (! true)) ; => true

; Equality is `equal` or `=`.
(= 1 1) ; => true
(equal 2 1) ; => false

; For example, inequality would be combinding the not and equal functions.
(! (= 2 1)) ; => true

; More comparisons
(< 1 10) ; => true
(> 1 10) ; => false
; and their word counterpart.
(lesser 1 10) ; => true
(greater 1 10) ; => false

; Strings can be concatenated with +.
(+ "Hello " "world!") ; => "Hello world!"

; You can use JavaScript's comparative abilities.
(< 'a' 'b') ; => true
; ...and type coercion
(= '5' 5)

; The `at` or @ function will access characters in strings, starting at 0.
(at 0 'a') ; => 'a'
(@ 3 "foobar") ; => 'b'

; There is also the `null` and `undefined` variables.
null ; used to indicate a deliberate non-value
undefined ; user to indicate a value that hasn't been set

; Variables are declared with the `def` or `let` functions.
; Variab;es that haven't been set will be `undefined`.
(def some_var 5)
; `def` will keep the variable in the global context.
; `let` will only have the variable inside it's context, and has a wierder syntax.
(let ((a_var 5)) (+ a_var 5)) ; => 10
(+ a_var 5) ; = undefined + 5 => undefined

; Lists are arrays of values of any type.
; They basically are just forms without functions at the beginning.
(1 2 3) ; => [1, 2, 3] (JavaScript syntax)

; Dictionaries are Whip's equivalent to JavaScript 'objects' or Python 'dictionaries'
; or Ruby 'hashes': an unordered collection of key-value pairs.
{"key1":"value1" "key2":2 3:3}

; Keys are just values, either identifier, number, or string.
(def my_dict {my_key:"my_value" "my other key":4})
; But in Whip, dictionaries get parsed like: value, colon, value; with whitespace between each.
; So that means
{"key": "value"
"another key"
: 1234
}
; is evaluated to the same as
{"key":"value" "another key":1234}

; Dictionary definitions can be accessed used the `at` function, like strings and lists.
(@ "my other key" my_dict) ; => 4

; Logic and control structures

; The `if` function is pretty simple, though different than most imperitave langs.
(if true "returned if first arg is true" "returned if first arg is false")
; => "returned if first arg is true"

; And for the sake of ternary operator legacy
; `?` is if's unused shortcut.
(? false true false) ; => false

; `both` is a logical 'and' statement, and `either` is a logical 'or'.
(both true true) ; => true
(both true false) ; => false
(either true false) ; => true
(either false false) ; => false
; And their shortcuts are
; & => both
; ^ => either
(& true true) ; => true
(^ false true) ; => true

; Lambdas

; Lambdas in Whip are declared with the `lambda` or `->` function.
; And functions are really just lambdas with names.
(def my_function (-> (x y) (+ (x y) 10)))
;         |       |    |         |
;         |       |    |    returned value(with scope containing argument vars)
;         |       | arguments
;         | lambda declaration function
;         |
;   name of the to-be-decalred lambda

(my_function 10 10) ; = (+ (+ 10 10) 10) => 30

; Obiously, all lambdas by definition are anonymous and
; technically always used anonymouesly. Redundancy.
((lambda (x) x) 10) ; => 10

;;; Comprehensive functions

; `range` or `..` generates a list of numbers for
; each number between it's two args.
(range 1 5) ; => (1 2 3 4 5)
(.. 0 2)    ; => (0 1 2)

; `map` applies it's first arg(which should be a lambda/function)
; to each item in the following arg(which should be a list)
(map (-> (x) (+ x 1)) (1 2 3)) ; => (2 3 4)

; Reduce
(reduce + (.. 1 5))
; equivalent to
((+ (+ (+ 1 2) 3) 4) 5)

; Note: map and reduce don't have shortcuts

; `slice` or `\` is just like JavaScript's .slice()
(slice (.. 1 5) 2) ; => (3 4 5)
(\ (.. 0 100) -5) ; => (96 97 98 99 100)

; `append` or `<<` is self expanatory
(append 4 (1 2 3)) ; => (1 2 3 4)
(<< "bar" ("foo")) ; => ("foo" "bar")

; Length is self explanatory.
(length (1 2 3)) ; => 3
(_ "foobar") ; => 6

;;; Haskell fluff
(head (1 2 3)) ; => 1
(tail (1 2 3)) ; => (2 3)
(last (1 2 3)) ; => 3
(init (1 2 3)) ; => (1 2)
(take 1 (1 2 3 4)) ; (1 2)
(drop 1 (1 2 3 4)) ; (3 4)
(min (1 2 3 4)) ; 1
(max (1 2 3 4)) ; 4
(elem 1 (1 2 3)) ; true
(elem "foo" {"foo":"bar"}) ; true
(elem "bar" {"foo":"bar"}) ; false
(reverse (1 2 3 4)) ; => (4 3 2 1)
(even 1) ; => false
(odd 1) ; => true
(words "foobar nachos cheese") ; => ("foobar" "nachos" "cheese")
(unwords ("foo" "bar")) ; => "foobar"
(pred 21) ; => 20
(succ 20) ; => 21
