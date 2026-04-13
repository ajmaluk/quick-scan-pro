import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:quickscan_pro/core/theme/dimensions.dart';
import 'scanner_frame.dart';

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Backdrop Blur for a refined look
        Positioned.fill(
          child: RepaintBoundary(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        // Dimmed background with a hole in the middle
        RepaintBoundary(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.7),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Center(
                  child: Container(
                    width: AppDimensions.scannerFrameSize,
                    height: AppDimensions.scannerFrameSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // The Scanner Frame (Corner brackets + Laser)
        const Center(
          child: RepaintBoundary(
            child: ScannerFrame(),
          ),
        ),
      ],
    );
  }
}
