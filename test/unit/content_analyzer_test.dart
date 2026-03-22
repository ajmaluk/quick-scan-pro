import 'package:flutter_test/flutter_test.dart';
import 'package:quickscan_pro/core/utils/content_analyzer.dart';

void main() {
  group('ContentAnalyzer Tests', () {
    test('Detects URL', () {
      expect(ContentAnalyzer.analyze('https://google.com'), ScanType.url);
      expect(ContentAnalyzer.analyze('http://example.com/path'), ScanType.url);
      expect(ContentAnalyzer.analyze('www.test.info'), ScanType.url);
    });

    test('Detects Email', () {
      expect(ContentAnalyzer.analyze('mailto:test@example.com'), ScanType.email);
      expect(ContentAnalyzer.analyze('user.name+tag@domain.co.uk'), ScanType.email);
    });

    test('Detects WiFi', () {
      expect(ContentAnalyzer.analyze('WIFI:T:WPA;S:MyNetwork;P:password;;'), ScanType.wifi);
    });

    test('Detects Phone', () {
      expect(ContentAnalyzer.analyze('tel:+1234567890'), ScanType.phone);
      expect(ContentAnalyzer.analyze('+442071234567'), ScanType.phone);
    });

    test('Detects SMS', () {
      expect(ContentAnalyzer.analyze('SMSTO:+1234567890:Hello'), ScanType.sms);
    });

    test('Detects Geo', () {
      expect(ContentAnalyzer.analyze('geo:37.7749,-122.4194'), ScanType.geo);
      expect(ContentAnalyzer.analyze('https://maps.google.com/?q=loc:1,2'), ScanType.url); // Should technically be URL but analyze handles it
    });

    test('Detects UPI Payment', () {
      expect(ContentAnalyzer.analyze('upi://pay?pa=test@upi&pn=Test'), ScanType.upi);
    });

    test('Detects VCard Contact', () {
      expect(ContentAnalyzer.analyze('BEGIN:VCARD\nFN:John Doe\nEND:VCARD'), ScanType.contact);
    });

    test('Detects Product (Barcode)', () {
      expect(ContentAnalyzer.analyze('12345678'), ScanType.product);
      expect(ContentAnalyzer.analyze('1234567890123'), ScanType.product);
    });

    test('Fallback to Text', () {
      expect(ContentAnalyzer.analyze('Just some random text'), ScanType.text);
    });
  });
}
