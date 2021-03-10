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

func readWord(source: string, i: int): (string, int) =
  var str = ""
  var j = 0
  while i + j < source.len and not source[i + j].baseToken():
    str.add(source[i + j])
    j += 1
  (str, j - 1)

func tokenize*(source: string): seq[Token] = 
  var i = 0
  while i < source.len:
    case source[i]:
      of '\\':
        result.add(Token(ttype: LAMBDA))
      of '.':
        result.add(Token(ttype: DOT))
      of '(':
        result.add(Token(ttype: LPAREN))
      of ')':
        result.add(Token(ttype: RPAREN))
      of ' ':      # just skip white space
         i += 1
         continue
      else:        # must be ID term
        let (name, inc) = readWord(source, i)
        i += inc
        result.add(Token(ttype: ID, name: name))
    i += 1