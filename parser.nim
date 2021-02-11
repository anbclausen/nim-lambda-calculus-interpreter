import grammar
import strutils

func parse*(s: string): Term =
    if s.startsWith('\\'):
        let ss = s.substr(1)
        let payload = ss.split('.')
        let b = parse(payload[1])
        return Term(kind: Abs, param: payload[0], body: b)
    else:
        return Term(kind: Var, id: s)