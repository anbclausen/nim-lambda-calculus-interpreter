import strutils, parser, lexer, pprinter, interpreter, sequtils

while true:
    write(stdout, "λ] ")
    let inp = readLine(stdin).strip()

    if inp == "quit":
        echo "Goodbλe!"
        break
    
    echo pprint(tokenize(toSeq(inp.items)))