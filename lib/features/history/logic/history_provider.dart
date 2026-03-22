import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickscan_pro/data/models/scan_history.dart';
import 'package:quickscan_pro/data/local/hive_service.dart';

/// A provider that manages the state of the scan history.
final historyProvider = StateNotifierProvider<HistoryNotifier, List<ScanHistory>>((ref) {
  return HistoryNotifier();
});

/// A StateNotifier that handles loading, adding, deleting, and updating scan history.
class HistoryNotifier extends StateNotifier<List<ScanHistory>> {
  ValueListenable<Box<ScanHistory>>? _scansListenable;
  VoidCallback? _boxListener;

  HistoryNotifier() : super([]) {
    _loadHistory();
  }

  /// Loads the history from Hive and listens for changes.
  void _loadHistory() {
    try {
      state = HiveService.scansBox.values.toList().reversed.toList();

      // Listen for box changes to keep state in sync
      _scansListenable = HiveService.scansBox.listenable();
      _boxListener = () {
        if (mounted) {
          state = HiveService.scansBox.values.toList().reversed.toList();
        }
      };
      _scansListenable?.addListener(_boxListener!);
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
  }

  int _findBoxIndexById(String id) {
    final box = HiveService.scansBox;
    for (int i = 0; i < box.length; i++) {
      final item = box.getAt(i);
      if (item?.id == id) return i;
    }
    return -1;
  }

  /// Adds a new scan to the history. If a scan with the same content already exists,
  /// it is moved to the top and its favorite status is preserved.
  Future<void> addScan(ScanHistory scan) async {
    try {
      final existingIndex = state.indexWhere((s) => s.content == scan.content);

      if (existingIndex != -1) {
        final existingScan = state[existingIndex];
        // Preserve favorite status
        scan.isFavorite = existingScan.isFavorite;
        // Remove existing to move it to the top
        await deleteScanById(existingScan.id);
      }

      await HiveService.addScan(scan);
    } catch (e) {
      debugPrint('Error in HistoryNotifier.addScan: $e');
    }
  }


  /// Deletes a scan by id to avoid index mismatches after filtering.
  Future<void> deleteScanById(String id) async {
    try {
      final actualIndex = _findBoxIndexById(id);
      if (actualIndex != -1) {
        await HiveService.deleteScan(actualIndex);
      }
    } catch (e) {
      debugPrint('Error in HistoryNotifier.deleteScanById: $e');
    }
  }


  /// Toggles favorite by id to avoid mutating the wrong list item.
  Future<void> toggleFavoriteById(String id) async {
    try {
      final actualIndex = _findBoxIndexById(id);
      if (actualIndex == -1) return;
      final scan = HiveService.scansBox.getAt(actualIndex);
      if (scan != null) {
        scan.isFavorite = !scan.isFavorite;
        await HiveService.updateScan(actualIndex, scan);
      }
    } catch (e) {
      debugPrint('Error in HistoryNotifier.toggleFavoriteById: $e');
    }
  }

  /// Clears all scan history entries.
  Future<void> clearAll() async {
    try {
      await HiveService.clearAll();
    } catch (e) {
      debugPrint('Error in HistoryNotifier.clearAll: $e');
    }
  }

  @override
  void dispose() {
    if (_scansListenable != null && _boxListener != null) {
      _scansListenable!.removeListener(_boxListener!);
    }
    super.dispose();
  }
}
