class Token {
  String value;
  Token(this.value);
  String toString() => "Token('$value')";
}

class Lexer {
  static final _ignoreSyms = [' ', '\t', '\n', '\r'];

  static List<Token> tokenize(String src) {
    var tokens = List<Token>();
    for (var i = 0; i < src.length; i++) {
      if (src[i][0] == '(') {
        while (src[i][0] != ')') i++;
      } else if (src[i][0] == '\'') {
        var value = '\'';
        while (i < src.length && src[++i][0] != '\'') {
          value += src[i];
        }
        tokens.add(Token(value));
      } else if (src[i][0] == '#') {
        var value = '#';
        i++;
        while (i < src.length && src[++i][0] != '\'') {
          value += src[i];
        }
        tokens.add(Token(value));
      } else if (!_ignoreSyms.contains(src[i][0])) {
        var value = '';
        while (i < src.length && !_ignoreSyms.contains(src[i][0])) {
          value += src[i++];
        }
        tokens.add(Token(value));
      }
    }
    return tokens;
  }
}
