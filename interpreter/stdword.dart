import 'bexe.dart';
import 'core/block.dart';
import 'core/object.dart';
import 'lexer.dart';

/*
  Builtin слова
*/

const TRUE = 1;
const FALSE = 0;

final Map<String, Function> words = {
  'dup': (BVM vm) {
    vm.stack.push(vm.stack.peek());
  },
  'set': (BVM vm) {
    // [value name] top
    var name = vm.stack.pop().value as String;
    var value = vm.stack.pop();
    vm.frames.setVar(name, value);
  },
  'get': (BVM vm) {
    // [name] top
    var name = vm.stack.pop().value as String;
    vm.stack.push(vm.frames.getValueOfVat(name));
  },
  'const': (BVM vm) {
    // [value name] top
    var name = vm.stack.pop().value as String;
    var value = vm.stack.pop();
    vm.constants[name] = value;
  },
  'call': (BVM vm) {
    // [block] top
    var block = vm.stack.pop();
    if (block is BlockObject) {
      vm.frames.pushFrame();
      vm.frames.loadFrame(block.oldScope);
      vm.executeCode(block.value);
      vm.frames.popFrame();
    } else if (block.value is List<Token>) {
      vm.frames.pushFrame();
      vm.executeCode(block.value);
      vm.frames.popFrame();
    }
  },
  'load': (BVM vm) {
    // [block-scope] top
    var block = vm.stack.peek() as BlockObject;
    vm.frames.loadFrame(block.oldScope);
  },
  'list': (BVM vm) {
    // [..n size] top
    var size = vm.stack.pop().value as int;
    var newArray = List<BObject>();
    for (var i = 0; i < size; i++) {
      newArray.add(vm.stack.pop());
    }
    vm.stack.push(BObject(newArray));
  },
  'reverse': (BVM vm) {
    var array = vm.stack.pop().value as List<BObject>;
    vm.stack.push(BObject(array.reversed.toList()));
  },
  'hash': (BVM vm) {
    // [array] top
    var array = vm.stack.pop().value as List<BObject>;
    var hash = Map<String, BObject>();
    for (var i = 0; i < array.length; i++) {
      hash[array[i].value as String] = array[++i];
    }
    vm.stack.push(BObject(hash));
  },
  'map': (BVM vm) {
    // [array block] top
    var block = vm.stack.pop().value as List<Token>;
    var array = vm.stack.pop().value as List<BObject>;
    var newArray = List<BObject>();
    for (var item in array) {
      vm.stack.push(item);
      vm.executeCode(block);
      newArray.add(vm.stack.pop());
    }
    vm.stack.push(BObject(newArray));
  },
  'each': (BVM vm) {
    // [array block] top
    var block = vm.stack.pop().value as List<Token>;
    var array = vm.stack.pop().value as List<BObject>;
    for (var item in array) {
      vm.stack.push(item);
      vm.executeCode(block);
    }
  },
  'range': (BVM vm) {
    // [size] top
    var size = vm.stack.pop().value as int;
    var i = 1;
    vm.stack.push(BObject(List(size).map((_) => BObject(i++)).toList()));
  },
  'of': (BVM vm) {
    // [array | hash. index] top
    var indexkey = vm.stack.pop().value;
    var value = vm.stack.pop().value;
    if (value is List) {
      vm.stack.push((value as List<BObject>)[indexkey as int]);
    } else if (value is Map) {
      vm.stack.push((value as Map<String, BObject>)[indexkey as String]);
    }
  },
  'object': (BVM vm) {
    // DRY
    // [array] top
    var array = (vm.stack.pop().value as List<BObject>).reversed.toList();
    var hash = Map<String, BObject>();
    for (var i = 0; i < array.length; i++) {
      hash[array[i].value as String] = array[++i];
    }
    vm.stack.push(BObject(hash));
  },
  'scope': (BVM vm) {
    // [block] top
    var block = vm.stack.pop().value as List<Token>;
    vm.stack.push(BlockObject(block, vm.frames.peekFrame()));
  },
  ...lazy,
  ...base,
  ...io
};

final Map<String, Function> lazy = {
  'iter': (BVM vm) {
    // [array] top
    var array = vm.stack.pop().value as List<BObject>;
    Iterable t = array;
    vm.stack.push(BObject(t));
  },
  'lrange': (BVM vm) {
    var size = vm.stack.pop().value as int;
    var i = 1;
    Iterable t = List(size).map((_) => BObject(i++)).toList();
    vm.stack.push(BObject(t));
  }
};

final Map<String, Function> base = {
  'when': (BVM vm) {
    // [cond block] top
    var block = vm.stack.pop().value as List<Token>;
    var cond = vm.stack.pop().value as int;
    (cond > 0) ? vm.executeCode(block) : null;
  },
  'if': (BVM vm) {
    // [cond true-block false-block] top
    var falseBlock = vm.stack.pop().value as List<Token>;
    var trueBlock = vm.stack.pop().value as List<Token>;
    var cond = vm.stack.pop().value as int;
    (cond > 0) ? vm.executeCode(trueBlock) : vm.executeCode(falseBlock);
  },
  'while': (BVM vm) {
    // [cond-block body-block] top
    var body = vm.stack.pop().value as List<Token>;
    var cond = vm.stack.pop().value as List<Token>;
    while (true) {
      vm.executeCode(cond);
      if ((vm.stack.pop().value as int) <= 0) break;
      vm.executeCode(body);
    }
  }
};

final Map<String, Function> io = {
  'println': (BVM vm) {
    // [value] top
    print(vm.stack.pop());
  }
};
