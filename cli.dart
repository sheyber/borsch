import 'interpreter/bexe.dart';
import 'interpreter/lexer.dart';

Map _parseArgs(List<String> args) {
  var interface = {'body': List<String>(), 'keys': List<String>()};
  for (var arg in args) {
    if (arg.startsWith('-')) {
      interface['keys'].add(arg);
    } else {
      interface['body'].add(arg);
    }
  }
  return interface;
}

main(List<String> args) {
  var cli = _parseArgs(args);
  var closures = false;
  String type;
  for (var key in cli['keys']) {
    if (key == '--closures')
      closures = true;
    else if (key == '-e') {
      type = 'e';
    }
  }
  // eval
  if (type == 'e') {
    _evalCode(cli['body'].last, closures: closures);
  }
}

void _evalCode(String src, {bool closures = false}) {
  var vm = BVM(closures: closures);
  vm.frames.pushFrame();
  vm.executeCode(Lexer.tokenize(src));
}
