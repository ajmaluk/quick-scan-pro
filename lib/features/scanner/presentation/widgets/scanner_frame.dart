import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quickscan_pro/core/theme/colors.dart';
import 'package:quickscan_pro/core/theme/dimensions.dart';

class ScannerFrame extends StatelessWidget {
  const ScannerFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimensions.scannerFrameSize,
      height: AppDimensions.scannerFrameSize,
      child: Stack(
        children: [
          // Subtle outer glow for the entire frame area
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  blurRadius: 40,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

          // Corner Brackets (Minimalist)
          _buildCorner(Alignment.topLeft),
          _buildCorner(Alignment.topRight),
          _buildCorner(Alignment.bottomLeft),
          _buildCorner(Alignment.bottomRight),

          // Laser Line (Glowy)
          const ScannerLaserLine(),
        ],
      ),
    );
  }

  Widget _buildCorner(Alignment alignment) {
    final bool isLeft = alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;
    final bool isTop = alignment == Alignment.topLeft || alignment == Alignment.topRight;

    return Align(
      alignment: alignment,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border(
            top: isTop ? const BorderSide(color: AppColors.primary, width: 2.5) : BorderSide.none,
            bottom: !isTop ? const BorderSide(color: AppColors.primary, width: 2.5) : BorderSide.none,
            left: isLeft ? const BorderSide(color: AppColors.primary, width: 2.5) : BorderSide.none,
            right: !isLeft ? const BorderSide(color: AppColors.primary, width: 2.5) : BorderSide.none,
          ),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(
            duration: 2000.ms,
            color: Colors.white.withValues(alpha: 0.2),
          ),
    );
  }
}

class ScannerLaserLine extends StatelessWidget {
  const ScannerLaserLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 2,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.6),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0),
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0),
          ],
        ),
      ),
    ).animate(onPlay: (c) => c.repeat()).moveY(
          duration: 2000.ms,
          begin: 0,
          end: AppDimensions.scannerFrameSize,
          curve: Curves.easeInOutSine,
        );
  }
}
