import grammar

func pprint*(t: Term): string =
    case t.kind:
    of Var:
        t.id
    else:
        "pprint error"