import grammar
import strformat

func pprint*(t: Term): string =
    case t.kind:
    of Var:
        t.id
    of Abs:
        fmt"(λ{t.param}.{pprint(t.body)})"
    of App:
        fmt"{pprint(t.t1)} {pprint(t.t2)}"