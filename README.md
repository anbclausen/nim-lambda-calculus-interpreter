# Lambda Calculus Interpreter, written in Nim
This is a simple Lambda Calculus Interpreter, a personal project I'm doing for fun. I love Lambda Calculus and I'm very interested in Nim, a programming language I've recently discovered.

Note that I have taken a functional approach to writing this interpreter in Nim using the `fusion/matching` library.

## Prerequisites
You should have the `fusion` library installed. This is used for pattern matching.
```
nimble install fusion
```

Of course you need to have Nim installed: [Official Nim download page](https://nim-lang.org/install.html).

## How to run
Navigate to the file in your terminal. Write the following to compile and run the interpreter.
```
nim c -r main.nim 
```

## Examples
This interpreter outputs the result from the Lexer, the Parser and finally the interpreter.
```
λ] (\x.x) y
Tokens:   LPAREN LAMBDA x DOT x RPAREN y 
AST:      ((λx.x) y)
Result:   y
```

Renaming is implemented.
```
λ] (\x.\b.b x) b
Tokens:   LPAREN LAMBDA x DOT LAMBDA b DOT b x RPAREN b 
AST:      ((λx.(λb.(b x))) b)
Result:   (λb'.(b' b))
```

Try to have some fun with it! Here 2 + 3 in Lambda Calculus:
```
λ] (\m.\n.\s.\z.m s (n s z)) (\s.\z.s (s z)) (\s.\z.s (s (s z)))
Tokens:   LPAREN LAMBDA m DOT LAMBDA n DOT LAMBDA s DOT LAMBDA z DOT m s LPAREN n s z RPAREN RPAREN LPAREN LAMBDA s DOT LAMBDA z DOT s LPAREN s z RPAREN RPAREN LPAREN LAMBDA s DOT LAMBDA z DOT s LPAREN s LPAREN s z RPAREN RPAREN RPAREN 
AST:      (((λm.(λn.(λs.(λz.((m s) ((n s) z)))))) (λs.(λz.(s (s z))))) (λs.(λz.(s (s (s z))))))
Result:   (λs.(λz.(s (s (s (s (s z)))))))
```

And when you're done, simply write:
```
λ] quit
Goodbλe!
```

## TO DO
- Introduce `let` keyword to make life a little easier.