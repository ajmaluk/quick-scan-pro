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
    if (content.startsWith('http://') ||
        content.startsWith('https://') ||
        content.startsWith('www.') ||
        content.contains('http://') ||
        content.contains('https://')) {
      return ScanType.url;
    }

    if (content.toLowerCase().startsWith('mailto:') ||
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(content)) {
      return ScanType.email;
    }

    if (content.startsWith('WIFI:') || content.startsWith('wifi:')) {
      return ScanType.wifi;
    }

    if (content.startsWith('SMSTO:') ||
        content.startsWith('smsto:') ||
        content.startsWith('SMS:') ||
        content.startsWith('sms:')) {
      return ScanType.sms;
    }

    if (content.startsWith('geo:') || content.contains('google.com/maps')) {
      return ScanType.geo;
    }
    
    if (content.startsWith('upi://pay') || content.contains('upi://')) {
      return ScanType.upi;
    }

    if (content.startsWith('BEGIN:VCARD') || content.contains('VCARD')) {
      return ScanType.contact;
    }

    if (content.startsWith('BEGIN:VEVENT') || content.contains('VEVENT')) {
      return ScanType.event;
    }

    if (content.startsWith('BEGIN:VCALENDAR') || content.contains('VCALENDAR')) {
      return ScanType.event;
    }

    if (RegExp(r'^[0-9]{8,13}$').hasMatch(content)) {
      return ScanType.product;
    }

    if (content.startsWith('tel:') ||
        RegExp(r'^\+?[0-9]{7,15}$').hasMatch(content)) {
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
