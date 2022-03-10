#lang racket

(require parser-tools/lex
         (prefix-in : parser-tools/lex-sre))

(define-tokens value-tokens (NUMBER STRING))
(define-tokens var-tokens (IDENTIFIER))
(define-empty-tokens syntax-tokens
  (EOF
   ADD
   SUBTRACT
   PRODUCT
   DIVISION
   LT
   EQ
   ASSIGN
   NOT
   AND
   SEMI
   ASPAS
   LPAREN
   RPAREN
   IF
   THEN
   ELSE
   WHILE
   DO
   BEGIN
   END
   PRINTOUT
   READIN))

(define next-token
  (lexer-src-pos
   [(eof) (token-EOF)]
   [(:+ #\newline whitespace)
    (return-without-pos (next-token input-port))]
   [#\+ (token-ADD)]
   [#\- (token-SUBTRACT)]
   [#\* (token-PRODUCT)]
   [#\/ (token-DIVISION)]
   [#\< (token-LT)]
   ["==" (token-EQ)]
   ["<-" (token-ASSIGN)]
   ["!"  (token-NOT)]
   ["&&" (token-AND)]
   [";"  (token-SEMI)]
   ["("  (token-LPAREN)]
   [")"  (token-RPAREN)]
   ["if" (token-IF)]
   ["then" (token-THEN)]
   ["else" (token-ELSE)]
   ["while" (token-WHILE)]
   ["do" (token-DO)]
   ["begin" (token-BEGIN)]
   ["end" (token-END)]
   ["printout" (token-PRINTOUT)]
   ["readin" (token-READIN)]
   [(:: #\" (:*(complement #\"))#\") (token-STRING lexeme)]   
   [(:: alphabetic (:* (:+ alphabetic numeric)))
    (token-IDENTIFIER lexeme)]
   

   
   [(:: numeric (:* numeric))
    (token-NUMBER (string->number lexeme))
    ]))

(provide next-token value-tokens var-tokens syntax-tokens)
