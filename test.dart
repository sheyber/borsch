import 'interpreter/bexe.dart';
import 'interpreter/lexer.dart';

main(List<String> args) {
  var vm = BVM(); // BVM(closures: true);
  vm.frames.pushFrame();
  vm.executeCode(Lexer.tokenize(" { #'{ 1 2 3 }' 4 5 6 } "));
  print(vm.stack);
  print(vm.frames);
  print(vm.constants);
  print(vm.words_);
  // print(Lexer.tokenize(" #'{ 1 2 3 }' ")..toString());
}
