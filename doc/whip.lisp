; Comments, however not yet implemented, will start with semi-colons like so.

; Whip is written in "forms", which are just
; lists of things inside parens, separated by whitespace.

; Strings and numbers are straight forward. Use double-quotes.
"foo" ; => "foo"
1 ; => 1

; Decimal are auto-detected
3.14 ; => 3.14

; If a form starts with a function the function is called with the following
; form elements as it's arguments, otherwise the form is treated as a list

; An example function call
(print "Hello world!") ; => "Hello world!"

; Math and pretty much everything is done via a function
(+ 1 1) ; => 2
(- 2 1) ; => 1
(* 1 2) ; => 2
(/ 2 1) ; => 2
; even modulo
(% 9 4) ; => 1

; Equality is =
(= 1 1) ; => true
(= 2 1) ; => false

; You need not for logic, too
(not true) ; => false

; For most non-haskell originating functions have a shortcut counterpart.
; not's on is '!'
(! true) ; => false
; and we already used equal's (=+

; Nesting forms works as you expect
(+ 1 (- 3 2)) ; = 1 + (3 - 2) => 2

; Lists are like so
(1 2 3) ; => [1, 2, 3]
; The `at` function is act your service
; Lists start at 0
(at 2 (1 2 3)) ; => 2
; at's shortcut is a :
(: 0 (42 56 78)) ; => 42

;; Booleans

; if you're familiar with other languages means
; of boolean operators, then this will be cake
(= 10 10) ; = 10 = 10 => true
(> 10 5)  ; = 10 > 5  => true
(< 10 5)  ; = 10 < 5  => false
(both true true)     ; => true
(both true false)    ; => false
(either true false)  ; => true
(either false false) ; => false
; all these words are getting hard to type.
; & => both
; ^ => either
(& true true) ; true
(^ false true) ; true

;; Conditionals
(if true "true was the truth" "true was false") ; => "true was the truth"
; I don't know if you'd use it, but ? => if
(? true true false) ; => true

;; Lambdas
; lambdas are pretty self explanatory
(lambda (x) x) ; => function
; remember, the function atom itself needs to be
; at the beginning of a list to be called
; and '->' => lambda
((-> () "foo")) ; => "foo"
((-> (x) (+ x 1)) 1) ; = 1 + 1 => 2

;; Comprehensions

; Range
(range 1 5) ; => (1 2 3 4 5)
(.. 0 2)    ; => (0 1 2)

; Map
; map applies it's first arg(which should be a function)
; to each item in the following arg(which should be a list)
(map (-> (x) (+ x 1)) (1 2 3)) ; => (2 3 4)

; Reduce
(reduce + (.. 1 5))
; equivalent to
((+ (+ (+ 1 2) 3) 4) 5)

; Note: map and reduce don't have shortcuts

; Slice
(slice (.. 1 5) 2) ; => (3 4 5)
(\ (.. 0 100) -5) ; => (96 97 98 99 100)

; Append
(append 4 (1 2 3)) ; => (1 2 3 4)
(<< "bar" ("foo")) ; => ("foo" "bar")

; Length
(length (1 2 3)) ; => 3
(_ "foobar") ; => 6

;; Dictionaries
; dictionaries are like:
; ruby hashes
; or python dictionaries
; or javascript objects
{"key":"value"}
; you can also use numbers...
{1:42}
; to get these values use at
(: "name" {"name": "bob" "age": 40}) ; => "bob"

;; Haskell fluff
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
