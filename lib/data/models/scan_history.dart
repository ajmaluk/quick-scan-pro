import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'scan_history.g.dart';

@HiveType(typeId: 0)
class ScanHistory extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final String type; // url, email, phone, etc.

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  bool isFavorite;

  @HiveField(5)
  final String format;

  ScanHistory({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isFavorite = false,
    required this.format,
  });

  factory ScanHistory.create({
    required String content,
    required String type,
    required String format,
  }) {
    return ScanHistory(
      id: const Uuid().v4(),
      content: content,
      type: type,
      timestamp: DateTime.now(),
      format: format,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'isFavorite': isFavorite,
      'format': format,
    };
  }

  factory ScanHistory.fromJson(Map<String, dynamic> json) {
    return ScanHistory(
      id: json['id'],
      content: json['content'],
      type: json['type'],
      timestamp: DateTime.parse(json['timestamp']),
      isFavorite: json['isFavorite'] ?? false,
      format: json['format'],
    );
  }
}
