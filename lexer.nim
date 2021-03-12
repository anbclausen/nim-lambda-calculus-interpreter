import fusion/matching
{.experimental: "caseStmtMacros".}

type
    TokenType* = enum
        LAMBDA,
        DOT,
        LPAREN,
        RPAREN,
        ID,
    Token* = ref object
        case ttype* : TokenType
        of ID:
            name*: string
        else:
            discard

func baseToken(c: char): bool =
    c == '\\' or c == '.' or c == '(' or c == ')' or c == ' '

func tokenize*(source: seq[char]): seq[Token] = 
    case source:
        of []:
            return @[]
        of ['\\', all @tail]:
            return @[Token(ttype: LAMBDA)] & tokenize(tail)
        of ['.', all @tail]:
            return @[Token(ttype: DOT)] & tokenize(tail)
        of ['(', all @tail]:
            return @[Token(ttype: LPAREN)] & tokenize(tail)
        of [')', all @tail]:
            return @[Token(ttype: RPAREN)] & tokenize(tail)
        of [' ', until != ' ', all @tail]:
            return tokenize(tail)
        of [until @a.baseToken(), all @tail]:
            return Token(ttype: ID, name: cast[string](a)) & tokenize(tail)