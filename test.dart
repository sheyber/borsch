import 'interpreter/bexe.dart';
import 'interpreter/lexer.dart';

main(List<String> args) {
  var vm = BVM(); // BVM(closures: true);
  vm.frames.pushFrame();
  vm.executeCode(Lexer.tokenize(" [ dup * ] "));
  print(vm.stack);
  print(vm.frames);
  print(vm.constants);
  // print(Lexer.tokenize('[ dup * ]')..toString());
}
