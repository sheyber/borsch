import 'core/block.dart';
import 'core/frames.dart';
import 'core/object.dart';
import 'core/stack.dart';
import 'lexer.dart';
import 'stdword.dart';

// Виртуальная машина борщленга
class BVM {
  BStack stack;
  Map<String, BObject> constants;
  Frames frames;
  Map<String, BlockObject> words_;

  bool _closures; // Возможны ошибки

  BVM({bool closures = false})
      : stack = BStack(),
        constants = {},
        frames = Frames(),
        words_ = {},
        _closures = closures;

  void executeCode(List<Token> tokens) {
    for (var i = 0; i < tokens.length; i++) {
      var current = tokens[i].value;
      if (current.startsWith(RegExp(r'[0-9]'))) {
        // оброботка чисел
        stack.push(BObject(int.parse(current)));
      } else if (current.startsWith('\'')) {
        // оброботка строк
        stack.push(BObject(current.replaceFirst('\'', '')));
      } else if (current.startsWith('#')) {
        var toks = Lexer.tokenize(current.replaceFirst('#', ''));
        executeCode(toks);
      } else if (current == '[') {
        // оброботка блока
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
        // оброботка массива
        var array = List<BObject>();
        while (i < tokens.length && tokens[++i].value != '}') {
          array.add(_evalAsBObject(tokens[i].value));
        }
        stack.push(BObject(array));
      } else if (current == ':') {
        var name = tokens[++i].value;
        var body = List<Token>();
        i++;
        while (i < tokens.length && tokens[i].value != ';') {
          body.add(tokens[i++]);
        }
        words_[name] = BlockObject(body, frames.peekFrame());
      } else if (current.startsWith(RegExp(r'[a-zA-z]'))) {
        // оброботка слов
        if (constants.containsKey(current)) {
          stack.push(constants[current]);
        } else if (words_.containsKey(current)) {
          var block = words_[current];
          frames.pushFrame();
          frames.loadFrame(block.oldScope);
          executeCode(block.value as List<Token>);
          frames.popFrame();
        } else {
          executeWord(current);
        }
      } else {
        // оброботка символов
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
      case '-':
        var b = stack.pop().value as int;
        var a = stack.pop().value as int;
        stack.push(BObject(a - b));
        break;
      case '/':
        var b = stack.pop().value as int;
        var a = stack.pop().value as int;
        stack.push(BObject(a ~/ b));
        break;
      case '>':
        var b = stack.pop().value as int;
        var a = stack.pop().value as int;
        stack.push(BObject((a > b) ? TRUE : FALSE));
        break;
      case '<':
        var b = stack.pop().value as int;
        var a = stack.pop().value as int;
        stack.push(BObject((a < b) ? TRUE : FALSE));
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
    t = t.trim();
    if (t.startsWith(RegExp(r'[0-9]'))) {
      return BObject(int.parse(t));
    } else if (t.startsWith('\'')) {
      return BObject(t.replaceFirst('\'', ''));
    } else if (t.startsWith('#')) {
      var toks = Lexer.tokenize(t.replaceFirst('#', ''));
      executeCode(toks);
      return stack.pop();
    }
    return BObject(t);
  }
}
