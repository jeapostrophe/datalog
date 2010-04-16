#lang scheme
(require scheme/list
         (except-in (planet dherman/pprint:4) empty)
         "ast.ss"
         "pretty.ss"
         "runtime.ss")

(define current-theory (make-parameter (make-mutable-theory)))

(define (assume-if-safe assume thy s)
  (let ([c (assertion-clause s)])
    (if (safe-clause? c)
        (assume thy c)
        (raise-syntax-error 'datalog
                            "Unsafe clause in assertion"
                            (datum->syntax #f (pretty-format (format-statement s)) (assertion-srcloc s))))))

(define (print-literals ls)
  (pretty-print 
   (format-literals ls)))

(define (eval-program p)
  (for-each (lambda (s)
              (define v (eval-statement s))
              (unless (void? v)
                (print-literals v)))
            p))
(define (eval-statement s)
  (cond
    [(assertion? s)
     (assume-if-safe assume! (current-theory) s)]
    [(retraction? s)
     (retract! (current-theory) (retraction-clause s))]
    [(query? s)
     (prove (current-theory) (query-literal s))]))

(define (eval-program/fresh p)
  (let loop ([thy (make-immutable-theory)]
             [p p])
    (if (empty? p)
        thy
        (let ([s (first p)])
          (loop
           (cond
             [(assertion? s)
              (assume-if-safe assume thy s)]
             [(retraction? s)
              (retract thy (retraction-clause s))]
             [(query? s)
              (print-literals (prove thy (query-literal s)))
              thy])
           (rest p))))))

(provide/contract
 [current-theory (parameter/c mutable-theory/c)]
 [eval-program (program/c . -> . void)]
 [eval-statement (statement/c . -> . (or/c void (listof literal?)))]
 [eval-program/fresh (program/c . -> . immutable-theory/c)])