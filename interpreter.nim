import fusion/matching, ast
{.experimental: "caseStmtMacros".}

func substitute(t: T, id: string, t2: T): T =
    case t:
        of T(t: Var, id: id):
            t2
        of T(t: Var, id: _):
            t
        of @a is T(t: Abs, param: id, body: @body):
            case t2:
                of T(t: Var, id: id):
                    let nid = id & "'"
                    T(t: Abs, param: nid, body: substitute(body.substitute(id, T(t: Var, id: nid)), id, t2))
                else:
                    a
        of T(t: Abs, param: @param, body: @body):
            case t2:
                of T(t: Var, id: param):
                    let nid = param & "'"
                    T(t: Abs, param: nid, body: substitute(body.substitute(param, T(t: Var, id: nid)), id, t2))
                else:
                    T(t: Abs, param: param, body: body.substitute(id, t2))
        of T(t: App, t1: @t1, t2: @t3):
            T(t: App, t1: t1.substitute(id, t2), t2: t3.substitute(id, t2))
        else:
            raise newException(Exception, "λ-Eval Error: Error while substituting.")

func eval*(t: T): T =
    case t:
        of T(t: Var, id: _):
            t
        of T(t: Abs, param: @id, body: @body):
            T(t: Abs, param: id, body: eval(body))
        of T(t: App, t1: @t1 is T(t: Var, id: _), t2: @t2):
            T(t: App, t1: t1, t2: eval(t2))
        of T(t: App, t1: T(t: Abs, param: @id, body: @body), t2: @t2):
            eval(body.substitute(id, eval(t2)))
        of T(t: App, t1: @t1 is T(t: App, t1: _, t2: _), t2: @t2):
            let temp = T(t: App, t1: eval(t1), t2: eval(t2))
            func varAtBottom(t: T): bool =
                case t:
                    of T(t: App, t1: @t1, t2: _):
                        varAtBottom(t1)
                    of T(t: Var, id: _):
                        true
                    else:
                        false
            if varAtBottom(temp):
                temp
            else:
                eval(T(t: App, t1: eval(t1), t2: eval(t2)))
        else:
            raise newException(Exception, "λ-Eval Error: Didn't match on any terms.")