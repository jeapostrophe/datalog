#lang setup/infotab
(define name "Datalog")
(define blurb
  (list "An implementation of Datalog as a PLT Scheme language."))
(define scribblings '(["scribblings/datalog.scrbl" (multi-page)]))
(define categories '(devtools))
(define version "0.2")
(define primary-file "main.ss")
(define compile-omit-paths '("tests"))
(define release-notes (list))
(define repositories '("4.x"))