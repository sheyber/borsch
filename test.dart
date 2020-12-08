import 'interpreter/bexe.dart';
import 'interpreter/lexer.dart';

main(List<String> args) {
  var vm = BVM(); // BVM(closures: true);
  vm.frames.pushFrame();
  vm.executeCode(Lexer.tokenize(
      " 0 i set [ i get 10 < ] [ i get 1 + i set ] while 10 5 / "));
  print(vm.stack);
  print(vm.frames);
  print(vm.constants);
  // print(Lexer.tokenize('[ dup * ]')..toString());
}
