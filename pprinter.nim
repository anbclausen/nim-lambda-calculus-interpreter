import grammar

proc pprint*(t: Term): string =
    if t of Var:
        let x = Var(t)
        x.id
    else:
        "pprint error"