enum ScanType {
  url,
  email,
  phone,
  wifi,
  sms,
  geo,
  contact,
  event,
  product,
  upi,
  text,
}

class ContentAnalyzer {
  static ScanType analyze(String content) {
    if (content.isEmpty) return ScanType.text;
    
    final trimmed = content.trim();

    if (trimmed.startsWith('http://') ||
        trimmed.startsWith('https://') ||
        trimmed.startsWith('www.') ||
        trimmed.contains('http://') ||
        trimmed.contains('https://')) {
      return ScanType.url;
    }

    if (trimmed.toLowerCase().startsWith('mailto:') ||
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(trimmed)) {
      return ScanType.email;
    }

    if (trimmed.startsWith('WIFI:') || trimmed.startsWith('wifi:')) {
      return ScanType.wifi;
    }

    if (trimmed.startsWith('SMSTO:') ||
        trimmed.startsWith('smsto:') ||
        trimmed.startsWith('SMS:') ||
        trimmed.startsWith('sms:')) {
      return ScanType.sms;
    }

    if (trimmed.startsWith('geo:') || trimmed.contains('google.com/maps')) {
      return ScanType.geo;
    }
    
    if (trimmed.startsWith('upi://pay') || trimmed.contains('upi://')) {
      return ScanType.upi;
    }

    if (trimmed.startsWith('BEGIN:VCARD') || trimmed.contains('VCARD')) {
      return ScanType.contact;
    }

    if (trimmed.startsWith('BEGIN:VEVENT') || trimmed.contains('VEVENT')) {
      return ScanType.event;
    }

    if (trimmed.startsWith('BEGIN:VCALENDAR') || trimmed.contains('VCALENDAR')) {
      return ScanType.event;
    }

    if (RegExp(r'^[0-9]{8,13}$').hasMatch(trimmed)) {
      return ScanType.product;
    }

    if (trimmed.startsWith('tel:') ||
        RegExp(r'^\+?[0-9]{7,15}$').hasMatch(trimmed)) {
      return ScanType.phone;
    }

    return ScanType.text;
  }

  static String getTypeName(ScanType type) {
    switch (type) {
      case ScanType.url:
        return 'URL';
      case ScanType.email:
        return 'Email';
      case ScanType.phone:
        return 'Phone';
      case ScanType.wifi:
        return 'WiFi';
      case ScanType.sms:
        return 'SMS';
      case ScanType.geo:
        return 'Location';
      case ScanType.contact:
        return 'Contact';
      case ScanType.event:
        return 'Event';
      case ScanType.product:
        return 'Product';
      case ScanType.upi:
        return 'Payment (UPI)';
      case ScanType.text:
        return 'Text';
    }
  }
}
