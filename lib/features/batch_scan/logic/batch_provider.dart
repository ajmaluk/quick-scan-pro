import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickscan_pro/data/models/scan_history.dart';

final batchProvider = StateNotifierProvider<BatchNotifier, BatchState>((ref) {
  return BatchNotifier();
});

class BatchState {
  final List<ScanHistory> scans;
  final bool isPaused;

  BatchState({
    this.scans = const [],
    this.isPaused = false,
  });

  BatchState copyWith({
    List<ScanHistory>? scans,
    bool? isPaused,
  }) {
    return BatchState(
      scans: scans ?? this.scans,
      isPaused: isPaused ?? this.isPaused,
    );
  }
}

class BatchNotifier extends StateNotifier<BatchState> {
  BatchNotifier() : super(BatchState());

  void addScan(ScanHistory scan) {
    // Prevent immediate duplicate
    if (state.scans.isNotEmpty && state.scans.last.content == scan.content) {
      return;
    }
    state = state.copyWith(scans: [...state.scans, scan]);
  }

  void removeScan(int index) {
    final newList = List<ScanHistory>.from(state.scans);
    newList.removeAt(index);
    state = state.copyWith(scans: newList);
  }

  void togglePause() {
    state = state.copyWith(isPaused: !state.isPaused);
  }

  void clearBatch() {
    state = state.copyWith(scans: []);
  }
}
