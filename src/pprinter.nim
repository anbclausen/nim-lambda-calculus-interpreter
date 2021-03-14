import ast, lexer, strformat

func pprint*(t: T): string =
    case t.t:
    of Var:
        t.id
    of Abs:
        fmt"(λ{t.param}.{pprint(t.body)})"
    of App:
        fmt"({pprint(t.t1)} {pprint(t.t2)})"

func pprint*(tokens: seq[Token]): string =    # to pretty print the lexer's output
    for i in 0 ..< tokens.len:
        case tokens[i].ttype:
        of LAMBDA:
            result.add("LAMBDA ")
        of DOT:
            result.add("DOT ")
        of RPAREN:
            result.add("RPAREN ")
        of LPAREN:
            result.add("LPAREN ")
        of ID:
            result.add(tokens[i].name & " ")
