#lang racket

(require parser-tools/yacc
         "lexer.rkt"
         "syntax.rkt")

(define prop-test-parser
  (parser
   (start statements)
   (end EOF)
   (tokens value-tokens var-tokens syntax-tokens)
   (src-pos)
   (error
    (lambda (a b c d e)
      (begin
        (printf "a = ~a\nb = ~a\nc = ~a\nd = ~a\ne = ~a\n"
                a b c d e) (void))))
   (precs
    (nonassoc NOT EQ LT)
    (left ADD SUBTRACT)
    (left PRODUCT DIVISION AND))
   (grammar
    (statements [() '()]
                [(statement statements) (cons $1 $2)])
    
    (statement [(IDENTIFIER ASSIGN expr SEMI) (assign (var $1) $3)]
               [(PRINTOUT expr SEMI) (sprint $2)]
               [(IF expr THEN block ELSE block) (eif $2 $4 $6)]
               [(WHILE expr DO block) (ewhile $2 $4)]
               [(READIN expr SEMI) (input (var $2))])
    
    (block [(BEGIN statements END) $2])
    (expr  [(NUMBER) (value $1)]
           [(IDENTIFIER) (var $1)]
           ;[(STRING) (value $1)]

           [(ASPAS expr ASPAS) (value $2)]

           
           [(expr ADD expr) (add $1 $3)]
           [(expr SUBTRACT expr) (minus $1 $3)]
           [(expr PRODUCT expr) (mult $1 $3)]
           [(expr DIVISION expr) (divv $1 $3)]
           [(expr LT expr) (lt $1 $3)]
           [(expr EQ expr) (eeq $1 $3)]
           [(expr AND expr) (eand $1 $3)]
           [(NOT expr) (enot $2)]
           [(LPAREN expr RPAREN) $2]))
   ))

(define (parse ip)
  (prop-test-parser (lambda () (next-token ip))))

(provide parse)
