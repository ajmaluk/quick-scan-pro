import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:quickscan_pro/core/navigation/shared_axis_route.dart';
import 'package:quickscan_pro/core/theme/colors.dart';
import 'package:quickscan_pro/core/theme/text_styles.dart';
import 'package:quickscan_pro/core/constants/strings.dart';
import 'package:quickscan_pro/core/widgets/press_scale.dart';
import 'package:quickscan_pro/core/utils/scan_deduplicator.dart';
import 'package:quickscan_pro/features/scanner/logic/scanner_provider.dart';
import 'package:quickscan_pro/features/scanner/presentation/widgets/scanner_overlay.dart';
import 'package:quickscan_pro/features/scanner/presentation/widgets/scan_result_sheet.dart';
import 'package:quickscan_pro/features/batch_scan/presentation/screens/batch_scanner_screen.dart';
import 'package:quickscan_pro/features/home/logic/home_tab_provider.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  final Future<PermissionStatus> Function()? permissionRequestOverride;
  final Future<bool> Function()? openAppSettingsOverride;
  final String? debugCameraErrorMessage;

  const ScannerScreen({
    super.key,
    this.permissionRequestOverride,
    this.openAppSettingsOverride,
    this.debugCameraErrorMessage,
  });

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  final ImagePicker _picker = ImagePicker();
  final ScanDeduplicator _scanDeduplicator = ScanDeduplicator();
  bool _hasPermission = false;
  bool _isCheckingPermission = true;
  bool _isPermissionPermanentlyDenied = false;
  bool _isHandlingDetection = false;
  double _baseScale = 0.0;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    if (mounted) {
      setState(() {
        _isCheckingPermission = true;
      });
    }

    try {
      final status = await (widget.permissionRequestOverride?.call() ?? Permission.camera.request())
          .timeout(const Duration(seconds: 5), onTimeout: () => PermissionStatus.denied);

      if (mounted) {
        setState(() {
          _hasPermission = status.isGranted;
          _isPermissionPermanentlyDenied = status.isPermanentlyDenied || status.isRestricted;
          _isCheckingPermission = false;
        });
        
        if (_hasPermission) {
          // Additional safety: ensure controller is ready
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              ref.read(scannerProvider.notifier).resume();
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCheckingPermission = false;
        });
      }
    }
  }

  void _onScaleStart(ScaleStartDetails details) {
    _baseScale = ref.read(scannerProvider).zoomScale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.scale == 1.0) return;
    final double newScale = (_baseScale + (details.scale - 1.0)).clamp(0.0, 1.0);
    ref.read(scannerProvider.notifier).setZoom(newScale);
  }

  Future<void> _scanFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final scannerNotifier = ref.read(scannerProvider.notifier);
      final BarcodeCapture? capture = await scannerNotifier.controller.analyzeImage(image.path);
      if (capture != null && capture.barcodes.isNotEmpty) {
        _onBarcodeDetected(capture.barcodes.first);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.noQRFound)));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.failedAnalyze)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingPermission) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (!_hasPermission) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.videocam_off_rounded, color: AppColors.textDimmed, size: 64),
                const SizedBox(height: 24),
                Text(AppStrings.cameraRequired, style: AppTextStyles.h2, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text(AppStrings.cameraRequiredDesc, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isPermissionPermanentlyDenied ? openAppSettings : _checkPermission,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(_isPermissionPermanentlyDenied ? AppStrings.openSettings : AppStrings.grantPermission),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(AppStrings.goBack, style: TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final scannerState = ref.watch(scannerProvider);
    final scannerNotifier = ref.read(scannerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        child: Stack(
          children: [
            // Camera Preview
            if (widget.debugCameraErrorMessage != null)
              _buildCameraErrorView(widget.debugCameraErrorMessage!)
            else
              MobileScanner(
                controller: scannerNotifier.controller,
                fit: BoxFit.cover,
                placeholderBuilder: (context, child) => Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(color: AppColors.primary),
                ),
                onDetect: (capture) {
                  if (capture.barcodes.isNotEmpty) _onBarcodeDetected(capture.barcodes.first);
                },
                errorBuilder: (context, error, child) => _buildCameraErrorView(AppStrings.cameraFailed),
              ),

            // Custom Overlay
            const ScannerOverlay(),

            // Glassmorphic Top Bar
            Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: RepaintBoundary(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildGlassButton(
                            icon: Icons.close_rounded,
                            onTap: () => Navigator.of(context).pop(),
                            label: AppStrings.close,
                          ),
                          Row(
                            children: [
                              _buildGlassButton(
                                icon: scannerState.isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                                onTap: () => scannerNotifier.toggleFlash(),
                                color: scannerState.isFlashOn ? Colors.amber : Colors.white,
                                label: AppStrings.flash,
                              ),
                              const SizedBox(width: 8),
                              _buildGlassButton(
                                icon: Icons.flip_camera_ios_rounded,
                                onTap: () => scannerNotifier.toggleCamera(),
                                label: AppStrings.switchCamera,
                              ),
                              const SizedBox(width: 8),
                              _buildGlassButton(
                                icon: Icons.layers_rounded,
                                onTap: () => Navigator.of(context).pushReplacement(SharedAxisPageRoute(
                                  page: const BatchScannerScreen(),
                                  transitionType: SharedAxisTransitionType.horizontal,
                                )),
                                label: AppStrings.batchScan,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Zoom Slider (Vertical Minimalist)
            Positioned(
              right: 24,
              top: 150,
              bottom: 220,
              child: _buildVerticalZoomSlider(scannerState.zoomScale, scannerNotifier),
            ),

            // Bottom Controls (Obsidian Lens)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    AppStrings.scanPrompt,
                    style: AppTextStyles.labelMedium.copyWith(color: Colors.white.withValues(alpha: 0.6)),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildSecondaryButton(icon: Icons.image_rounded, label: AppStrings.gallery, onTap: _scanFromGallery),
                      _buildPulsingScanButton(),
                      _buildSecondaryButton(
                        icon: Icons.history_rounded,
                        label: AppStrings.history,
                        onTap: () {
                          ref.read(homeTabProvider.notifier).state = 1;
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onBarcodeDetected(Barcode barcode) {
    if (barcode.rawValue == null || !mounted || _isHandlingDetection) return;
    if (!_scanDeduplicator.shouldProcess(barcode.rawValue!, DateTime.now())) return;
    
    _isHandlingDetection = true;
    Vibrate.feedback(FeedbackType.success);
    ref.read(scannerProvider.notifier).pause();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ScanResultSheet(content: barcode.rawValue!, format: barcode.format.name),
    ).then((_) {
      if (mounted) {
        ref.read(scannerProvider.notifier).resume();
        _isHandlingDetection = false;
      }
    });
  }

  Widget _buildVerticalZoomSlider(double value, ScannerNotifier notifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.add_rounded, color: Colors.white, size: 16),
        const SizedBox(height: 8),
        Expanded(
          child: RotatedBox(
            quarterTurns: 3,
            child: Semantics(
              label: 'Zoom Slider',
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: Colors.white10,
                  thumbColor: Colors.white,
                  trackHeight: 2,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(value: value, onChanged: (v) => notifier.setZoom(v)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Icon(Icons.remove_rounded, color: Colors.white, size: 16),
      ],
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
    required String label,
    Color color = Colors.white,
  }) {
    return Semantics(
      label: label,
      button: true,
      child: PressScale(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return Semantics(
      label: label,
      button: true,
      child: PressScale(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.labelSmall.copyWith(color: Colors.white.withValues(alpha: 0.7))),
          ],
        ),
      ),
    );
  }

  Widget _buildPulsingScanButton() {
    return Semantics(
      label: AppStrings.scanQrCode,
      button: true,
      child: RepaintBoundary(
        child: Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1.5),
          ),
          child: Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 20),
                ],
              ),
              child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 32),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.08, 1.08),
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildCameraErrorView(String message) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            Text(message, style: AppTextStyles.bodyLarge.copyWith(color: Colors.white), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _checkPermission, child: const Text(AppStrings.retry)),
          ],
        ),
      ),
    );
  }
}
