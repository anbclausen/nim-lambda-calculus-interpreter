type
    MyKind*    = enum
        Var, 
        Abs, 
        App,
    T*   = ref object 
        case t*: MyKind
        of Var: 
            id*: string
        of Abs:
            param*: string
            body*: T
        of App:
            t1*: T
            t2*: T