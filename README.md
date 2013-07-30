Whip: A LISPy language
======================

See goal.md for details on how the language will eventually be.
For now, this README will be what I have implemented so far.

``` lisp
; literals
1 ; 1.0
1.1 ; 1.0
"a string" ; "a string"

; lists
(1 2) ; [1, 2]
("foo" 5 "bar")

; lambdas
(lambda (arg1 arg2) (reduce + "part of return value" arg1 arg2))
; syntactic alternative is '->'
((-> (name, item) (reduce + (name " hates " item))) "Bob" "duct tape") ; "Bob hates duct tape"

; variables
(let ((x 5) (y 10)) (
  (x) ; 5
  (+ x y)) ; 15
x ; undefined error

; standard functions
(+ 36 6) ; 36 + 6 => 42
(- 50 8) ; 50 - 8 => 42
(* 7 6) ; 7 * 6   => 42
(/ 84 2) ; 84 / 2 => 42

; comparatives
(equal 10 10) ; true
(greater 10 5) ; true
(lesser 5 10) ; true
(not (equal 5 10)) ; true
(either (equal 10 10) (equal 5 10)) ; true
(both (equal 10 10) (equal 5 10)) ; false
; syntax alternatives
; =: equal
; >: greater
; <: lesser
; !: not
; ^: either
; &: both
(= 10 10) ; true
(> 10 5) ; true
(< 5 10) ; true
(! (= 5 10)) ; true
(^ (= 10 10) (= 5 10)) ; true
(& (= 10 10) (= 5 10)) ; false

; conditionals
(if true "true was true" "true was false")
; syntactic alternative
(? (= 10 11) "if true" "if false") ; false

; comprehensions
(reduce + (1 2 3))
; same as
(+ (+ 1 2) 3)
(map (lambda (x) (+ x 1)) (1 2 3)) ; [2, 3, 4]

; get value at index of list
(at 1 (1 2)) ; 1
; syntactic alternative
(: 2 (3 4)) ; 4

; append to array
(append 5 (1 2 3 4)) ; [1, 2, 3, 4, 5]
; syntactic alternative
(<< "bar" ("foo")) ; ["foo", "bar"]

; length of an array
(length (1 2)) ; 2
; syntactic alternative
(_ (1 2 3 4 5)) ; 5

; printing...
(print "foo")
```
