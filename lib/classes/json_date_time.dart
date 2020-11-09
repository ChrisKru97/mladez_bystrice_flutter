class JsonDateTime {
  JsonDateTime(this.value);

  final DateTime value;

  String toJson() => value.toIso8601String();
}
