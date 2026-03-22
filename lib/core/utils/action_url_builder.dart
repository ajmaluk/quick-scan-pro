import 'package:quickscan_pro/core/utils/content_analyzer.dart';

class ActionUrlBuilder {
  static Uri? buildPrimaryUri(ScanType type, String content) {
    switch (type) {
      case ScanType.url:
        return _buildWebUri(content);
      case ScanType.geo:
        return _buildGeoUri(content);
      case ScanType.phone:
        return _tryParse('tel:$content');
      case ScanType.email:
        return _tryParse('mailto:$content');
      case ScanType.upi:
        return _tryParse(content);
      default:
        return null;
    }
  }

  static Uri buildSearchUri(String content) {
    return Uri.parse('https://www.google.com/search?q=${Uri.encodeComponent(content)}');
  }

  static Uri? _buildWebUri(String input) {
    final raw = input.trim();
    if (raw.isEmpty) return null;
    final withScheme = raw.contains('://') ? raw : 'https://$raw';
    final uri = _tryParse(withScheme);
    if (uri == null) return null;
    if (!uri.hasAuthority) return null;
    if (uri.scheme != 'http' && uri.scheme != 'https') return null;
    return uri;
  }

  static Uri? _buildGeoUri(String input) {
    final raw = input.trim();
    if (raw.isEmpty) return null;
    if (raw.startsWith('geo:')) return _tryParse(raw);
    return _tryParse('https://maps.google.com/?q=${Uri.encodeComponent(raw)}');
  }

  static Uri? _tryParse(String value) {
    try {
      return Uri.parse(value);
    } catch (_) {
      return null;
    }
  }

  static Map<String, String> parseVCard(String content) {
    final Map<String, String> data = {};
    final lines = content.split('\n');
    for (var line in lines) {
      final l = line.trim();
      if (l.startsWith('FN:')) {
        data['name'] = l.substring(3);
      } else if (l.startsWith('N:')) {
        if (!data.containsKey('name')) {
          final parts = l.substring(2).split(';');
          data['name'] = parts.where((p) => p.isNotEmpty).join(' ');
        }
      } else if (l.startsWith('TEL:')) {
        data['phone'] = l.substring(4);
      } else if (l.startsWith('EMAIL:')) {
        data['email'] = l.substring(6);
      } else if (l.startsWith('ORG:')) {
        data['org'] = l.substring(4);
      }
    }
    return data;
  }
}