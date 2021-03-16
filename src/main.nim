import parser, lexer, pprinter, interpreter, sequtils

proc run(inp: cstring): cstring {.exportc.} =
    let tokens = tokenize(toSeq(inp.items))
    let ast = parse(tokens)
    let res = eval(ast)
    let print = pprint(res)
    cstring(print)