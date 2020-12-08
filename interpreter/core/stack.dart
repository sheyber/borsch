import 'object.dart';

class BStack {
  List<BObject> _data;

  BStack() : _data = [];

  void push(BObject object) {
    _data.add(object);
  }

  BObject pop() {
    if (!_data.isEmpty) {
      return _data.removeLast();
    }
    throw 'Stack is empty';
  }

  BObject peek([int index]) {
    if (!_data.isEmpty) {
      if (index != null && index < _data.length) {
        return _data[index];
      } else {
        return _data.last;
        // throw 'The index >= stack size';
      }
    }
    throw 'Stack is empty';
  }

  List<BObject> getStack() => _data;
  String toString() => _data.toString();
}
