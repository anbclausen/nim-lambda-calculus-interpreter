import fusion/matching
{.experimental: "caseStmtMacros".}

type
    TokenType* = enum
        LAMBDA,
        DOT,
        LPAREN,
        RPAREN,
        ID,
        DEFAS
    Token* = ref object
        case ttype* : TokenType
        of ID:
            name*: string
        else:
            discard

func baseToken(c: char): bool =
    c == '\\' or c == '.' or c == '(' or c == ')' or c == ' ' or c == ':'

func tokenize*(source: seq[char]): seq[Token] = 
    case source:
        of []:
            @[]
        of ['\\', all @tail]:
            @[Token(ttype: LAMBDA)] & tokenize(tail)
        of ['.', all @tail]:
            @[Token(ttype: DOT)] & tokenize(tail)
        of ['(', all @tail]:
            @[Token(ttype: LPAREN)] & tokenize(tail)
        of [')', all @tail]:
            @[Token(ttype: RPAREN)] & tokenize(tail)
        of [':', '=', all @tail]:
            @[Token(ttype: DEFAS)] & tokenize(tail)
        of [' ', until != ' ', all @tail]:
            tokenize(tail)
        of [until @a.baseToken(), all @tail]:
            Token(ttype: ID, name: cast[string](a)) & tokenize(tail)
        else:
            raise newException(Exception, "λ-Lexer Error: Illegal symbol encountered.")