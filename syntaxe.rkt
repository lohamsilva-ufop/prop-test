#lang racket

; sintaxe de expressões

(struct value
  (value)
  #:transparent)

(struct var
  (id)
  #:transparent)


; sintaxe de declarações

(struct assign
  (var expr)
  #:transparent)

(struct sprint
  (expr)
  #:transparent)

(provide (all-defined-out))
