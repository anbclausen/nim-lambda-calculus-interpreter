import grammar
import lexer

func parse*(prog: seq[Token]): Term =
    Term(kind: Var, id: "")