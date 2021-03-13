type
    MyKind*    = enum
        Var, 
        Abs, 
        App,
    MyTerm*   = ref object 
        case mykind*: MyKind
        of Var: 
            id*: string
        of Abs:
            param*: string
            body*: MyTerm
        of App:
            t1*: MyTerm
            t2*: MyTerm