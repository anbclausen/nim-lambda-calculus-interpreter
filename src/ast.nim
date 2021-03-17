type
    TermType*    = enum
        Var, 
        Abs, 
        App,
        Def,
        Empty,
    T*   = ref object         # Term
        case t*: TermType     # type
        of Var: 
            id*: cstring
        of Abs:
            param*: cstring
            body*: T
        of App:
            t1*: T
            t2*: T
        of Def:
            name*: cstring
            val*: T
        of Empty:
            discard