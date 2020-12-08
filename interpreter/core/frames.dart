import 'object.dart';

class Frame {
  Map<String, BObject> data;
  Frame() : data = Map();
  String toString() => data.toString();
}

class Frames {
  List<Frame> frames;

  Frames() : frames = [];

  void pushFrame([Frame frame]) {
    frames.add((frame == null) ? Frame() : frame);
  }

  Frame popFrame() => frames.removeLast();

  void setVar(String name, BObject value) {
    for (var i = 0; i < frames.length; i++) {
      if (frames[i].data.containsKey(name)) {
        frames[i].data[name] = value;
        return;
      }
    }
    frames[frames.length - 1].data[name] = value;
  }

  BObject getValueOfVat(String name) {
    for (var frame in frames) {
      if (frame.data.containsKey(name)) {
        return frame.data[name];
      }
    }
    throw 'KeyError';
  }

  String toString() => frames.toString();
}
