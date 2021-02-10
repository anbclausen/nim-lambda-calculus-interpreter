type
    Kind*    = enum
        Var, Abs, App
    Term*   = object 
        case kind*: Kind
        of Var: 
            id*: string
        of Abs:
            x*: string
            body*: ref Term
        of App:
            t1*: ref Term
            t2*: ref Term