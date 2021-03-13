import fusion/matching, grammar, lexer
{.experimental: "caseStmtMacros".}

func parse*(prog: seq[Token]): Term =
    case prog:
        of [Token(ttype: LAMBDA), Token(ttype: ID, name: @name), Token(ttype: DOT), all @body]:
            Term(kind: Abs, param: name, body: parse(body))
        of [Token(ttype: ID, name: @name)]:
            Term(kind: Var, id: name)
        else:
            raise newException(Exception, "Couldn't parse. Illegal AST.")