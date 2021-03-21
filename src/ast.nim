type
    TermType*    = enum
        Var, 
        Abs, 
        App,
        Def,
        Empty,
    Expr*   = ref object         # Term
        case exprtype*: TermType     # type
        of Var: 
            id*: string
        of Abs:
            param*: string
            body*: Expr
        of App:
            e1*: Expr
            e2*: Expr
        of Def:
            name*: string
            val*: Expr
        of Empty:
            discard