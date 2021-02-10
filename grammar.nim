type
    Kind*    = enum
        Var, 
        Abs, 
        App,
    Term*   = ref object 
        case kind*: Kind
        of Var: 
            id*: string
        of Abs:
            param*: string
            body*: Term
        of App:
            t1*: Term
            t2*: Term