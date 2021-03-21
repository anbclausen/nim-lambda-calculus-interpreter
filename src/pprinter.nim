import ast, lexer, strformat

func pprint*(e: Expr): string =
    case e.exprtype:
        of Var:
            e.id
        of Abs:
            fmt"(λ{e.param}.{pprint(e.body)})"
        of App:
            fmt"({pprint(e.e1)} {pprint(e.e2)})"
        of Def:
            fmt"{e.name} := {pprint(e.val)}"
        of Empty:
            ""

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
            of DEFAS:
                result.add("DEFAS ")
