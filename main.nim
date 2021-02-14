import strutils
import parser
import lexer
import pprinter
import interpreter

while true:
    write(stdout, "λ] ")
    let inp = readLine(stdin).strip()

    if inp == "quit":
        echo "Goodbλe!"
        break
    
    echo pprint(tokenize(inp))