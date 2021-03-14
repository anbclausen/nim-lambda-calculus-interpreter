import fusion/matching, sequtils, sugar, ast, lexer, tables
{.experimental: "caseStmtMacros".}

func matchingParenthesis(prog: seq[Token]): (seq[Token], seq[Token]) =
    ## Takes sequence of tokens without initial `(`
    ## and finds the matching `)`.
    ## 
    ## Returns a tuple with inner expression of 
    ## parentheses, and the rest of the prog.
    let mappings = {LPAREN: -1, RPAREN: 1, DOT: 0, LAMBDA: 0, ID: 0}.toTable
    let vals = prog.map(t => mappings[t.ttype])
    var i = 0
    var bal = -1
    while bal < 0 and i < vals.len:
        bal += vals[i]
        inc i
    if bal < 0:
        raise newException(Exception, "λ-Parse Error: Mismatched parentheses.")
    if i == prog.len:
        (prog[0..<i-1], @[])
    else:
        (prog[0..<i-1], prog[i..^1])

func parse*(prog: seq[Token]): T =
    func findAtoms(subprog: seq[Token]): seq[seq[Token]] =
        ## Finds all atoms on form `Var` or `(Exp)`
        ## in sequence of tokens.
        case subprog:
            of []:
                return @[]
            of [Token(ttype: ID, name: @name)]:
                return @[@[Token(ttype: ID, name: name)]]
            of [Token(ttype: ID, name: @name), .._]:
                return @[@[Token(ttype: ID, name: name)]] & findAtoms(subprog[1..^1])
            of [Token(ttype: LPAREN), all @tail]:
                let (inner, rest) = matchingParenthesis(tail)
                return @[inner] & findAtoms(rest)
            else:
                raise newException(Exception, "λ-Parse Error: Atoms have to be on form Var or (Exp).")

    func genApplication(atoms: seq[seq[Token]]): T =
        ## Generates term consisting only of left-associative 
        ## applications from atoms on form `Var` or `(Exp)`.
        case atoms:
            of [@a]:
                return parse(a)
            else: 
                return T(t: App, t1: genApplication(atoms[0..^2]), t2: parse(atoms[^1]))

    case prog:
        of [Token(ttype: LAMBDA), Token(ttype: ID, name: @name), Token(ttype: DOT), all @body]:
            return T(t: Abs, param: name, body: parse(body))
        of [Token(ttype: ID, name: @name)]:
            return T(t: Var, id: name)
        else:
            return genApplication(findAtoms(prog))