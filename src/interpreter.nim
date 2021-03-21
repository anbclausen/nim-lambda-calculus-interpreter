import fusion/matching, ast, tables
{.experimental: "caseStmtMacros".}

var store = initTable[string, Expr]()

proc expand(e: Expr): Expr =
    case e:
        of Expr(exprtype: Var, id: @id):
            if store.contains(id):
                store[id]
            else:
                e
        of Expr(exprtype: Abs, param: @param, body: @body):
            Expr(exprtype: Abs, param: param, body: expand(body))
        of Expr(exprtype: App, e1: @e1, e2: @e2):
            Expr(exprtype: App, e1: expand(e1), e2: expand(e2))
        else:
            raise newException(Exception, "λ-Eval Error: Error while expanding expression with value from store.")

func substitute(e: Expr, id: string, e2: Expr): Expr =
    case e:
        of Expr(exprtype: Var, id: id):
            e2
        of Expr(exprtype: Var, id: _):
            e
        of @a is Expr(exprtype: Abs, param: id, body: @body):
            case e2:
                of Expr(exprtype: Var, id: id):
                    let nid = id & "'"
                    Expr(exprtype: Abs, param: nid, body: substitute(body.substitute(id, Expr(exprtype: Var, id: nid)), id, e2))
                else:
                    a
        of Expr(exprtype: Abs, param: @param, body: @body):
            case e2:
                of Expr(exprtype: Var, id: param):
                    let nid = param & "'"
                    Expr(exprtype: Abs, param: nid, body: substitute(body.substitute(param, Expr(exprtype: Var, id: nid)), id, e2))
                else:
                    Expr(exprtype: Abs, param: param, body: body.substitute(id, e2))
        of Expr(exprtype: App, e1: @e1, e2: @e3):
            Expr(exprtype: App, e1: e1.substitute(id, e2), e2: e3.substitute(id, e2))
        else:
            raise newException(Exception, "λ-Eval Error: Error while substituting.")

proc eval*(e: Expr): Expr =
    proc evalExpr(e: Expr): Expr =
        case e:
            of Expr(exprtype: Var, id: @id):
                e
            of Expr(exprtype: Abs, param: @id, body: Expr(exprtype: Abs, param: @id2, body: @body)):            # for effeciency
                Expr(exprtype: Abs, param: id, body: Expr(exprtype: Abs, param: id2, body: evalExpr(body)))
            of Expr(exprtype: Abs, param: @id, body: @body):
                Expr(exprtype: Abs, param: id, body: evalExpr(body))
            of Expr(exprtype: App, e1: @e1 is Expr(exprtype: Var, id: _), e2: @e2):
                Expr(exprtype: App, e1: e1, e2: evalExpr(e2))
            of Expr(exprtype: App, e1: Expr(exprtype: Abs, param: @id, body: @body), e2: @e2):
                evalExpr(body.substitute(id, e2))
            of Expr(exprtype: App, e1: @e1 is Expr(exprtype: App, e1: _, e2: _), e2: @e2):
                let temp = Expr(exprtype: App, e1: evalExpr(e1), e2: e2)
                func varAtBottom(e: Expr): bool =
                    case e:
                        of Expr(exprtype: App, e1: @e1, e2: _):
                            varAtBottom(e1)
                        of Expr(exprtype: Var, id: _):
                            true
                        else:
                            false
                if varAtBottom(temp):
                    temp
                else:
                    evalExpr(Expr(exprtype: App, e1: evalExpr(e1), e2: e2))
            else:
                raise newException(Exception, "λ-Eval Error: Didn't match on any terms.")
    if e.exprtype == Def:
        store[e.name] = expand(e.val)
        return Expr(exprtype: Empty)
    let expanded = expand(e)
    return evalExpr(expanded)