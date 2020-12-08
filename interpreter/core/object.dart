class BObject {
  dynamic value;

  BObject(this.value);

  String repr() => "BObject($value)";
  String toString() => value.toString();
}
