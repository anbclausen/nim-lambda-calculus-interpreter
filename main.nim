import strutils
import parser
import pprinter
import interpreter

while true:
    write(stdout, "λ] ")
    let inp = readLine(stdin).strip()

    if inp == "quit":
        echo "Goodbλe!"
        break
    
    echo pprint(eval(parse(inp)))