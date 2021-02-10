import grammar

func parse*(s: string): Term =
    Term(kind: Var, id: s)