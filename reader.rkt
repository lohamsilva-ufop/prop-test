#lang racket

(require "parser.rkt"
         "interp.rkt"
         "syntax.rkt")

(provide (rename-out [prop-test-read read]
                     [prop-test-read-syntax read-syntax]))

(define (prop-test-read in)
  (syntax->datum
   (prop-test-read-syntax #f in)))

(define (prop-test-read-syntax path port)
  (datum->syntax
   #f
   `(module prop-test-mod racket
      ,(finish (prop-test-interp (parse port))))))

(define (finish env)
  (displayln "Finished!"))
