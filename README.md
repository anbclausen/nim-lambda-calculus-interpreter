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
Navigate to the folder in your terminal. Write the following to compile and run the interpreter.
```
nim c -r src/main.nim 
```

## Examples
```
λ] (\x.x) y
y
```

Renaming is implemented.
```
λ] (\x.\b.b x) b
(λb'.(b' b))
```

Assignment is implemented.
```
λ] ID := \x.x
λ] ID w
w
```

Try to have some fun with it! Here 2 + 3 = 5 in Lambda Calculus:
```
λ] 2 := \s.\z.s (s z)
λ] 3 := \s.\z.s (s (s z))
λ] + := \m.\n.\s.\z.m s (n s z)            
λ] + 2 3
(λs.(λz.(s (s (s (s (s z)))))))
```

And when you're done, simply write:
```
λ] quit
Goodbλe!
```