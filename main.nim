import strutils
import parser
import pprinter

while true:
    write(stdout, "λ] ")
    let inp = readLine(stdin).strip()

    if inp == "quit":
        break
    
    echo pprint(parse(inp))