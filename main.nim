import strutils, parser, lexer, pprinter, interpreter, sequtils

while true:
    write(stdout, "λ] ")
    let inp = readLine(stdin).strip()

    if inp == "quit":
        echo "Goodbλe!"
        break
    
    let tokens = tokenize(toSeq(inp.items))
    echo "Tokens:   ", pprint(tokens)
    let ast = parse(tokens)
    echo "Ast:      ", pprint(ast)
    let res = eval(ast)
    echo "Res:      ", pprint(res)