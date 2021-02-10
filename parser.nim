import grammar

func parse*(s: string): Term =
    return Var(id: s)