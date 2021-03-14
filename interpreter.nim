import fusion/matching, ast, pprinter
{.experimental: "caseStmtMacros".}

func rename(t: MyTerm, id: string, with: string): MyTerm =
    case t:
        of MyTerm(mykind: Var, id: id):
            MyTerm(mykind: Var, id: with)
        of MyTerm(mykind: Var, id: _):
            t
        of MyTerm(mykind: Abs, param: id, body: @body):
            MyTerm(mykind: Abs, param: with, body: body.rename(id, with))
        of MyTerm(mykind: Abs, param: @id, body: @body):
            MyTerm(mykind: Abs, param: id, body: body.rename(id, with))
        of MyTerm(mykind: App, t1: @t1, t2: @t2):
            MyTerm(mykind: App, t1: t1.rename(id, with), t2: t2.rename(id, with))
        else:
            raise newException(Exception, "λ-Eval Error: Error while renaming.")

func substitute(t: MyTerm, id: string, t2: MyTerm): MyTerm =
    case t:
        of MyTerm(mykind: Var, id: id):
            t2
        of MyTerm(mykind: Var, id: _):
            t
        of @a is MyTerm(mykind: Abs, param: id, body: @body):
            case t2:
                of MyTerm(mykind: Var, id: id):
                    let nid = id & "'"
                    MyTerm(mykind: Abs, param: nid, body: substitute(body.rename(id, nid), id, t2))
                else:
                    a
        of MyTerm(mykind: Abs, param: @param, body: @body):
            case t2:
                of MyTerm(mykind: Var, id: param):
                    let nid = param & "'"
                    MyTerm(mykind: Abs, param: nid, body: substitute(body.rename(param, nid), id, t2))
                else:
                    MyTerm(mykind: Abs, param: param, body: body.substitute(id, t2))
        of MyTerm(mykind: App, t1: @t1, t2: @t3):
            MyTerm(mykind: App, t1: t1.substitute(id, t2), t2: t3.substitute(id, t2))
        else:
            raise newException(Exception, "λ-Eval Error: Error while substituting.")

func eval*(t: MyTerm): MyTerm =
    case t:
        of MyTerm(mykind: Var, id: _):
            t
        of MyTerm(mykind: Abs, param: @id, body: @body):
            MyTerm(mykind: Abs, param: id, body: eval(body))
        of MyTerm(mykind: App, t1: @t1 is MyTerm(mykind: Var, id: _), t2: @t2):
            MyTerm(mykind: App, t1: t1, t2: eval(t2))
        of MyTerm(mykind: App, t1: MyTerm(mykind: Abs, param: @id, body: @body), t2: @t2):
            eval(body.substitute(id, eval(t2)))
        of MyTerm(mykind: App, t1: @t1 is MyTerm(mykind: App, t1: _, t2: _), t2: @t2):
            let temp = MyTerm(mykind: App, t1: eval(t1), t2: eval(t2))
            func varAtBottom(t: MyTerm): bool =
                case t:
                    of MyTerm(mykind: App, t1: @t1, t2: _):
                        varAtBottom(t1)
                    of MyTerm(mykind: Var, id: _):
                        true
                    else:
                        false
            if varAtBottom(temp):
                temp
            else:
                eval(MyTerm(mykind: App, t1: eval(t1), t2: eval(t2)))
        else:
            raise newException(Exception, "λ-Eval Error: Didn't match on any terms.")