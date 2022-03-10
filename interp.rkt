#lang racket

(require "syntax.rkt")

;; capturar um valOR

(define (read-value env v)
  (let ([x (read)])
      (hash-set env (var-id v) (value x))))




;; looking up an environment
;; lookup-env : environment * var -> environment * value

(define (lookup-env env v)
  (let* ([val (hash-ref env v #f)])
    (if val
        (cons env val)
        (cons (hash-set env v (value 0))
              (value 0)))))

(define (true-value? v)
  (eq? #t (value-value v)))

(define (op-value f env v1 v2)
  (cons env (value (f (value-value v1)
                      (value-value v2)))))

(define (eval-op f env e1 e2)
  (let* ([r1 (eval-expr env e1)]
         [r2 (eval-expr (car r1) e2)])
    (op-value f (car r2) (cdr r1) (cdr r2))))


;; eval-expr : env * expr -> env * expr

(define (eval-expr env e)
  (match e
    [(value val) (cons env (value val))]
    [(add e1 e2) (eval-op + env e1 e2)]
    [(minus e1 e2) (eval-op - env e1 e2)]
    [(mult e1 e2) (eval-op * env e1 e2)]
    [(divv e1 e2) (eval-op / env e1 e2)]
    [(lt e1 e2) (eval-op < env e1 e2)]
    [(eeq e1 e2) (eval-op eq? env e1 e2)]
    [(eand e1 e2) (eval-op (lambda (k1 k2) (and k1 k2)) env e1 e2)]
    [(enot e1) (let* ([r1 (eval-expr env e1)])
                 (cons (car r1)
                       (value (not (value-value (cdr r1))))))]
    [(var v) (lookup-env env (var-id v))]))

;; evaluating a statement

; eval-assign : environment * var * expr -> environment

(define (eval-assign env v e)
  (let* ([res (eval-expr env e)])
    (hash-set env v (cdr res))))

; eval-stmt : environment * statement -> environment

(define (eval-stmt env s)
  (match s

;leitura de dados
    [(input (var v))
     (begin
        (display "Entre com um valor:")
        (read-value env v))]



    
    [(assign v e) (eval-assign env (var-id v) e)]
    [(eif e1 blk1 blk2)
     (let ([c (eval-expr env e1)])
       (if (true-value? (cdr c))
           (eval-stmts env blk1)
           (eval-stmts env blk2)))]
    [(ewhile e1 blk1)
     (let ([c (eval-expr env e1)])
       (if (true-value? (cdr c))
           (eval-stmt (eval-stmts env blk1)
                      (ewhile e1 blk1))
           env))]



    
;mostrar dados
    [(sprint e1)
     (let ([v (eval-expr env e1)])
       (begin
         (displayln (value-value (cdr v)))
         env))]))


(define (eval-stmts env blk)
  (match blk
    ['() env]
    [(cons s blks) (let ([nenv (eval-stmt env s)])
                       (eval-stmts nenv blks))]))


(define (prop-test-interp prog)
  (eval-stmts (make-immutable-hash) prog))

(provide prop-test-interp eval-expr)