class JsonDateTime {
  final DateTime value;
  JsonDateTime(this.value);

  String toJson() => value != null ? value.toIso8601String() : null;
}