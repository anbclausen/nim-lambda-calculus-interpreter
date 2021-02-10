type
    Term*   = ref object of RootObj
    Var*    = ref object of Term
        id*: string
    Abs*    = ref object of Term
        id*: string
        body*: ref Term
    App*    = ref object of Term
        t1*: ref Term
        t2*: ref Term