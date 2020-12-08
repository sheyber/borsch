import 'dart:io';

import 'interpreter/bexe.dart';
import 'interpreter/lexer.dart';

const KEYS = {'--closures': 'Делает все блоки замыканиями.'};

List<String> _parseKeys(List<String> args) {
  var keys = List<String>();
  for (var arg in args) {
    if (arg.startsWith('-')) {
      keys.add(arg);
    }
  }
  return keys;
}

main(List<String> args) {
  if (args.length > 0) {
    var keys = _parseKeys(args);
    if (args[0] == 'run') {
      _evalCode(args[1], closures: keys.contains('--closures'));
    } else {
      var content = File(args[0]).readAsStringSync();
      _evalCode(content, closures: keys.contains('--closures'));
    }
  } else {
    print("Борщленг. ГыГ.");
    KEYS.forEach((key, value) {
      print('\t$key | $value');
    });
  }
}

void _evalCode(String src, {bool closures = false}) {
  var vm = BVM(closures: closures);
  vm.frames.pushFrame();
  vm.executeCode(Lexer.tokenize(src));
}
