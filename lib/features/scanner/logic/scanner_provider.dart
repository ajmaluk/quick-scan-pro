import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// A provider that manages the camera scanner state.
final scannerProvider =
    StateNotifierProvider<ScannerNotifier, ScannerState>((ref) {
  return ScannerNotifier();
});

/// Represents the current state of the camera scanner.
class ScannerState {
  final bool isFlashOn;
  final bool isPaused;
  final CameraFacing cameraFacing;
  final double zoomScale;

  ScannerState({
    this.isFlashOn = false,
    this.isPaused = false,
    this.cameraFacing = CameraFacing.back,
    this.zoomScale = 0.0,
  });

  ScannerState copyWith({
    bool? isFlashOn,
    bool? isPaused,
    CameraFacing? cameraFacing,
    double? zoomScale,
  }) {
    return ScannerState(
      isFlashOn: isFlashOn ?? this.isFlashOn,
      isPaused: isPaused ?? this.isPaused,
      cameraFacing: cameraFacing ?? this.cameraFacing,
      zoomScale: zoomScale ?? this.zoomScale,
    );
  }
}

/// A StateNotifier that controls the MobileScannerController and manages scanner settings.
class ScannerNotifier extends StateNotifier<ScannerState> {
  ScannerNotifier() : super(ScannerState());

  /// The controller for the mobile_scanner package.
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
    formats: [BarcodeFormat.all],
  );

  /// Toggles the device's flash/torch.
  void toggleFlash() {
    try {
      state = state.copyWith(isFlashOn: !state.isFlashOn);
      controller.toggleTorch();
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  /// Switches between the front and back camera.
  void toggleCamera() {
    try {
      final newFacing = state.cameraFacing == CameraFacing.back
          ? CameraFacing.front
          : CameraFacing.back;
      state = state.copyWith(cameraFacing: newFacing);
      controller.switchCamera();
    } catch (e) {
      debugPrint('Error switching camera: $e');
    }
  }

  /// Sets the zoom scale of the camera (0.0 to 1.0).
  void setZoom(double scale) {
    try {
      state = state.copyWith(zoomScale: scale);
      controller.setZoomScale(scale);
    } catch (e) {
      debugPrint('Error setting zoom: $e');
    }
  }

  /// Pauses the camera scanning process.
  void pause() {
    try {
      state = state.copyWith(isPaused: true);
      controller.stop();
    } catch (e) {
      debugPrint('Error pausing scanner: $e');
    }
  }

  /// Resumes the camera scanning process.
  void resume() {
    try {
      state = state.copyWith(isPaused: false);
      controller.start();
    } catch (e) {
      debugPrint('Error resuming scanner: $e');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
