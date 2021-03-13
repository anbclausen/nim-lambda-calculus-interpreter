import fusion/matching, grammar, lexer
{.experimental: "caseStmtMacros".}

proc matchingParen(prog: seq[Token]): (seq[Token], seq[Token]) =
    var i = 0
    var bal = -1
    while bal < 0 and i < prog.len:
        let peek = prog[i]
        if peek.ttype == LPAREN:
            dec bal
        elif peek.ttype == RPAREN:
            inc bal
        inc i
    if bal < 0:
        raise newException(Exception, "λ-Parse Error: Mismatched parentheses.")
    if i == prog.len:
        (prog[0..<i-1], @[])
    else:
        (prog[0..<i-1], prog[i..<prog.len])

proc parse*(prog: seq[Token]): Term =
    func app(prog: seq[Token]): Term =
        func findAtoms(subprog: seq[Token]): seq[seq[Token]] =
            case subprog:
                of []:
                    return @[]
                of [Token(ttype: ID, name: @name)]:
                    return @[@[Token(ttype: ID, name: name)]]
                of [Token(ttype: ID, name: @name), .._]:
                    return @[@[Token(ttype: ID, name: name)]] & findAtoms(subprog[1..^1])
                of [Token(ttype: LPAREN), all @tail]:
                    let (inner, rest) = matchingParen(tail)
                    return @[inner] & findAtoms(rest)
                else:
                    raise newException(Exception, "λ-Parse Error: Illegal AST.")
        func genTerm(atoms: seq[seq[Token]]): Term =
            case atoms.len:
                of 1:
                    return parse(atoms[0])
                else: 
                    return Term(kind: App, t1: genTerm(atoms[0..^2]), t2: parse(atoms[^1]))
        return genTerm(findAtoms(prog))
    case prog:
        of [Token(ttype: LAMBDA), Token(ttype: ID, name: @name), Token(ttype: DOT), all @body]:
            return Term(kind: Abs, param: name, body: parse(body))
        of [Token(ttype: ID, name: @name)]:
            return Term(kind: Var, id: name)
        else:
            return app(prog)