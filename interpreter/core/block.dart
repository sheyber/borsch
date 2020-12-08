import 'frames.dart';
import 'object.dart';

class BlockObject extends BObject {
  Frame oldScope;
  BlockObject(value, this.oldScope) : super(value);
  String toString() => 'Block{$value, $oldScope}';
}
