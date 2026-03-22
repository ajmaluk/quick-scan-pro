import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickscan_pro/core/theme/colors.dart';
import 'package:quickscan_pro/core/theme/text_styles.dart';
import 'package:quickscan_pro/core/utils/content_analyzer.dart';
import 'package:quickscan_pro/data/models/scan_history.dart';
import 'package:quickscan_pro/features/batch_scan/logic/batch_provider.dart';
import 'package:quickscan_pro/features/history/logic/history_provider.dart';

class BatchScannerScreen extends ConsumerStatefulWidget {
  const BatchScannerScreen({super.key});

  @override
  ConsumerState<BatchScannerScreen> createState() => _BatchScannerScreenState();
}

class _BatchScannerScreenState extends ConsumerState<BatchScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _hasPermission = false;
  bool _isCheckingPermission = true;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.request();
    if (mounted) {
      setState(() {
        _hasPermission = status.isGranted;
        _isCheckingPermission = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingPermission) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (!_hasPermission) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.videocam_off_rounded, color: AppColors.textDimmed, size: 64),
              const SizedBox(height: 24),
              Text('Camera Access Required', style: AppTextStyles.h2),
              const SizedBox(height: 32),
              ElevatedButton(onPressed: _checkPermission, child: const Text('Grant Permission')),
            ],
          ),
        ),
      );
    }

    final batchState = ref.watch(batchProvider);
    final batchNotifier = ref.read(batchProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildGlassHeader(batchNotifier),
          _buildStatsRow(batchState),
          _buildCameraPreview(batchState),
          _buildItemsHeader(batchState.scans),
          _buildItemsList(batchState, batchNotifier),
        ],
      ),
    );
  }

  Widget _buildGlassHeader(BatchNotifier notifier) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Theme.of(context).colorScheme.onSurface, size: 20),
          ),
          Text('Batch Mode', style: AppTextStyles.h3),
          IconButton(
            onPressed: () => notifier.clearBatch(),
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primary, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BatchState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _buildStatCard('Total Scanned', state.scans.length.toString(), Icons.qr_code_rounded),
          const SizedBox(width: 16),
          _buildStatCard('Unique Items', _getUniqueCount(state.scans).toString(), Icons.auto_awesome_rounded),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: AppTextStyles.h3.copyWith(fontSize: 18)),
                Text(label, style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview(BatchState state) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              MobileScanner(
                controller: _controller,
                onDetect: (capture) {
                  if (state.isPaused) return;
                  if (capture.barcodes.isNotEmpty) _onBarcodeDetected(capture.barcodes.first);
                },
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  color: Colors.black45,
                  child: Text(
                    'Position code inside the frame',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.labelSmall.copyWith(color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemsHeader(List<ScanHistory> scans) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Activity', style: AppTextStyles.h3.copyWith(fontSize: 18)),
          if (scans.isNotEmpty)
            TextButton(
              onPressed: () => _saveAll(scans),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Save All', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
            ),
        ],
      ),
    );
  }

  Widget _buildItemsList(BatchState state, BatchNotifier notifier) {
    if (state.scans.isEmpty) return Expanded(flex: 4, child: _buildEmptyState());

    return Expanded(
      flex: 4,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: state.scans.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final scan = state.scans[state.scans.length - 1 - index];
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.qr_code_rounded, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(scan.content, style: AppTextStyles.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(scan.format, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textDimmed)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => notifier.removeScan(state.scans.length - 1 - index),
                  icon: Icon(Icons.delete_outline_rounded, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4), size: 20),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.layers_clear_outlined, size: 48, color: AppColors.textDimmed.withValues(alpha: 0.2)),
        const SizedBox(height: 16),
        Text('Ready for bulk scanning', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDimmed)),
      ],
    );
  }

  int _getUniqueCount(List<ScanHistory> scans) {
    return scans.map((s) => s.content).toSet().length;
  }

  void _onBarcodeDetected(Barcode barcode) {
    final type = ContentAnalyzer.analyze(barcode.rawValue!);
    final scan = ScanHistory.create(
      content: barcode.rawValue!,
      type: ContentAnalyzer.getTypeName(type).toLowerCase(),
      format: barcode.format.name,
    );
    ref.read(batchProvider.notifier).addScan(scan);
  }

  void _saveAll(List<ScanHistory> scans) {
    if (scans.isEmpty) return;
    for (final scan in scans) {
      ref.read(historyProvider.notifier).addScan(scan);
    }
    ref.read(batchProvider.notifier).clearBatch();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved ${scans.length} items to history')),
    );
    Navigator.pop(context);
  }
}
