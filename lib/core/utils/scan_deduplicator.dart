class ScanDeduplicator {
  final Duration cooldown;
  String? _lastValue;
  DateTime? _lastAt;

  ScanDeduplicator({this.cooldown = const Duration(seconds: 2)});

  bool shouldProcess(String value, DateTime now) {
    if (_lastValue == null || _lastAt == null) {
      _lastValue = value;
      _lastAt = now;
      return true;
    }

    final isDuplicate = _lastValue == value;
    final withinCooldown = now.difference(_lastAt!) < cooldown;

    if (isDuplicate && withinCooldown) {
      return false;
    }

    _lastValue = value;
    _lastAt = now;
    return true;
  }

  void reset() {
    _lastValue = null;
    _lastAt = null;
  }
}