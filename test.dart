import 'interpreter/bexe.dart';
import 'interpreter/lexer.dart';

main(List<String> args) {
  var vm = BVM();
  vm.frames.pushFrame();
  vm.executeCode(Lexer.tokenize(
      " 'sqrt' [ dup * ] 2 list object math const    5 math sqrt of call"));
  print(vm.stack);
  print(vm.frames);
  print(vm.constants);
  // print(Lexer.tokenize('[ dup * ]')..toString());
}
