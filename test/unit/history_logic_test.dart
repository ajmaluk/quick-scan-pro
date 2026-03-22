import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickscan_pro/data/models/scan_history.dart';
import 'package:quickscan_pro/features/history/logic/history_provider.dart';
import 'package:quickscan_pro/core/constants/app_constants.dart';
import 'dart:io';

// Mocking Hive would be complex, let's use a real Hive box in a temp directory for integration-style unit test
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HistoryNotifier Deduplication Tests', () {
    late HistoryNotifier notifier;

    setUpAll(() async {
      // Setup temporary Hive
      final tempDir = await Directory.systemTemp.createTemp();
      Hive.init(tempDir.path);
      Hive.registerAdapter(ScanHistoryAdapter());
      await Hive.openBox<ScanHistory>(AppConstants.hiveBoxName);
    });

    setUp(() async {
      await Hive.box<ScanHistory>(AppConstants.hiveBoxName).clear();
      notifier = HistoryNotifier();
    });

    test('Adding unique scans increases state length', () async {
      await notifier.addScan(ScanHistory.create(content: 'test1', type: 'text', format: 'QR'));
      await notifier.addScan(ScanHistory.create(content: 'test2', type: 'text', format: 'QR'));
      
      expect(notifier.state.length, 2);
      expect(notifier.state.first.content, 'test2'); // Reversed order
    });

    test('Scanning same content moves it to top and preserves Favorite', () async {
      final scan1 = ScanHistory.create(content: 'duplicate', type: 'text', format: 'QR');
      await notifier.addScan(scan1);
      
      // Toggle favorite on the first one
      await notifier.toggleFavoriteById(notifier.state.first.id);
      expect(notifier.state.first.isFavorite, true);

      // Add another unique scan
      await notifier.addScan(ScanHistory.create(content: 'unique', type: 'text', format: 'QR'));
      expect(notifier.state.first.content, 'unique');
      expect(notifier.state.last.content, 'duplicate');

      // Scan the duplicate again
      await notifier.addScan(ScanHistory.create(content: 'duplicate', type: 'text', format: 'QR'));
      
      expect(notifier.state.length, 2); // Still 2 items
      expect(notifier.state.first.content, 'duplicate'); // Moved to top
      expect(notifier.state.first.isFavorite, true); // PRESERVED favorite!
    });
  });
}
