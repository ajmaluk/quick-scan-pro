import 'package:flutter/material.dart';
import 'package:quickscan_pro/core/theme/text_styles.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRPreviewCard extends StatelessWidget {
  final String data;
  final Color foregroundColor;
  final Color backgroundColor;
  final QrEyeShape eyeShape;
  final QrDataModuleShape dataModuleShape;

  const QRPreviewCard({
    super.key,
    required this.data,
    this.foregroundColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.eyeShape = QrEyeShape.square,
    this.dataModuleShape = QrDataModuleShape.square,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: foregroundColor.withValues(alpha: 0.1),
            blurRadius: 40,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.black.withValues(alpha: 0.4) 
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: data.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_2_rounded, color: foregroundColor.withValues(alpha: 0.1), size: 64),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Ready for generation',
                      style: AppTextStyles.labelSmall.copyWith(color: foregroundColor.withValues(alpha: 0.3)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : QrImageView(
              data: data,
              version: QrVersions.auto,
              size: 240,
              eyeStyle: QrEyeStyle(eyeShape: eyeShape, color: foregroundColor),
              dataModuleStyle: QrDataModuleStyle(dataModuleShape: dataModuleShape, color: foregroundColor),
              backgroundColor: Colors.transparent,
              errorCorrectionLevel: QrErrorCorrectLevel.M,
              padding: EdgeInsets.zero,
            ),
    );
  }
}
