import 'core/block.dart';
import 'core/frames.dart';
import 'core/object.dart';
import 'core/stack.dart';
import 'lexer.dart';
import 'stdword.dart';

class BVM {
  BStack stack;
  Map<String, BObject> constants;
  Frames frames;

  bool _closures;

  BVM({bool closures = false})
      : stack = BStack(),
        constants = {},
        frames = Frames(),
        _closures = closures;

  void executeCode(List<Token> tokens) {
    for (var i = 0; i < tokens.length; i++) {
      var current = tokens[i].value;
      if (current.startsWith(RegExp(r'[0-9]'))) {
        stack.push(BObject(int.parse(current)));
      } else if (current.startsWith('\'')) {
        stack.push(BObject(current.replaceFirst('\'', '')));
      } else if (current == '[') {
        var body = List<Token>();
        var brks = 1;

        while (i < tokens.length && brks > 0) {
          i++;
          if (tokens[i].value == '[') {
            brks++;
          } else if (tokens[i].value == ']') {
            brks--;
          }
          body.add(tokens[i]);
        }

        body.removeAt(body.length - 1);
        if (_closures) {
          stack.push(BlockObject(body, frames.peekFrame()));
        } else {
          stack.push(BObject(body));
        }
      } else if (current == '{') {
        var array = List<BObject>();
        while (i < tokens.length && tokens[++i].value != '}') {
          array.add(_evalAsBObject(tokens[i].value));
        }
        stack.push(BObject(array));
      } else if (current.startsWith(RegExp(r'[a-zA-z]'))) {
        if (constants.containsKey(current)) {
          stack.push(constants[current]);
        } else {
          executeWord(current);
        }
      } else {
        executeSym(current);
      }
    }
  }

  void executeSym(String sym) {
    switch (sym) {
      case '+':
        var a = stack.pop().value as int;
        var b = stack.pop().value as int;
        stack.push(BObject(a + b));
        break;
      case '*':
        var a = stack.pop().value as int;
        var b = stack.pop().value as int;
        stack.push(BObject(a * b));
        break;
    }
  }

  void executeWord(String word) {
    if (words.containsKey(word)) {
      words[word](this);
    } else {
      stack.push(BObject(word));
    }
  }

  BObject _evalAsBObject(String t) {
    if (t.startsWith(RegExp(r'[0-9]'))) {
      return BObject(int.parse(t));
    } else if (t.startsWith('\'')) {
      return BObject(t.replaceFirst('\'', ''));
    }
    return BObject(t);
  }
}
