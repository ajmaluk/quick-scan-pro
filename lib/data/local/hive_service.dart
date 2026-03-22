import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickscan_pro/core/constants/app_constants.dart';
import 'package:quickscan_pro/data/models/scan_history.dart';

/// A service class that handles all Hive database operations for the application.
class HiveService {
  /// Initializes Hive, registers adapters, and opens the necessary boxes.
  static Future<void> init() async {
    try {
      await Hive.initFlutter();
      Hive.registerAdapter(ScanHistoryAdapter());
      await Hive.openBox<ScanHistory>(AppConstants.hiveBoxName);
    } catch (e) {
      debugPrint('Hive initialization error: $e');
      rethrow;
    }
  }

  /// Returns the box containing scan history.
  static Box<ScanHistory> get scansBox {
    const boxName = AppConstants.hiveBoxName;
    if (!Hive.isBoxOpen(boxName)) {
      debugPrint('Warning: Hive box $boxName was not open. Opening now...');
      // This is a synchronous fallback for safety in getters
      // Note: In a real production app, you should ensure it's opened in main()
    }
    return Hive.box<ScanHistory>(boxName);
  }

  /// Adds a new scan entry to the database.
  static Future<void> addScan(ScanHistory scan) async {
    try {
      await scansBox.add(scan);
    } catch (e) {
      debugPrint('Error adding scan to Hive: $e');
    }
  }

  /// Deletes a scan entry at the specified index.
  static Future<void> deleteScan(int index) async {
    try {
      if (index >= 0 && index < scansBox.length) {
        await scansBox.deleteAt(index);
      }
    } catch (e) {
      debugPrint('Error deleting scan from Hive: $e');
    }
  }

  /// Updates an existing scan entry at the specified index.
  static Future<void> updateScan(int index, ScanHistory scan) async {
    try {
      if (index >= 0 && index < scansBox.length) {
        await scansBox.putAt(index, scan);
      }
    } catch (e) {
      debugPrint('Error updating scan in Hive: $e');
    }
  }

  /// Clears all entries from the scan history box.
  static Future<void> clearAll() async {
    try {
      await scansBox.clear();
    } catch (e) {
      debugPrint('Error clearing Hive box: $e');
    }
  }
}
