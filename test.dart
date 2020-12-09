import 'interpreter/bexe.dart';
import 'interpreter/lexer.dart';

main(List<String> args) {
  var vm = BVM(); // BVM(closures: true);
  vm.frames.pushFrame();
  vm.executeCode(Lexer.tokenize(": sqrt dup * ; 7 sqrt"));
  print(vm.stack);
  print(vm.frames);
  print(vm.constants);
  print(vm.words_);
  // print(Lexer.tokenize(': sqrt dup * ; 7 sqrt println')..toString());
}
