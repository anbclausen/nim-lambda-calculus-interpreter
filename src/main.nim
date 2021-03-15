import strutils, parser, lexer, pprinter, interpreter, sequtils

while true:
    write(stdout, "λ] ")
    let inp = readLine(stdin).strip()

    if inp == "quit":
        echo "Goodbλe!"
        break
    
    let tokens = tokenize(toSeq(inp.items))
    let ast = parse(tokens)
    let res = eval(ast)
    let print = pprint(res)
    if print != "":
        echo print