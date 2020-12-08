import 'interpreter/bexe.dart';
import 'interpreter/lexer.dart';

main(List<String> args) {
  if (args.first == '-e') {
    _evalCode(args.last);
  }
}

void _evalCode(String src) {
  var vm = BVM();
  vm.frames.pushFrame();
  vm.executeCode(Lexer.tokenize(src));
}
