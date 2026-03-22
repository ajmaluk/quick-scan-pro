import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickscan_pro/core/theme/colors.dart';
import 'package:quickscan_pro/core/theme/text_styles.dart';
import 'package:quickscan_pro/core/utils/content_analyzer.dart';

class QRTypeSelector extends StatelessWidget {
  final ScanType selectedType;
  final Function(ScanType) onTypeSelected;

  const QRTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<ScanType> types = [
      ScanType.text,
      ScanType.url,
      ScanType.wifi,
      ScanType.phone,
      ScanType.email,
      ScanType.contact,
      ScanType.sms,
      ScanType.geo,
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: types.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final type = types[index];
          final isSelected = type == selectedType;
          return _buildTypeItem(context, type, isSelected);
        },
      ),
    );
  }

  Widget _buildTypeItem(BuildContext context, ScanType type, bool isSelected) {
    IconData icon;
    String label = ContentAnalyzer.getTypeName(type);

    switch (type) {
      case ScanType.url: icon = Icons.link_rounded; break;
      case ScanType.email: icon = Icons.email_rounded; break;
      case ScanType.phone: icon = Icons.phone_rounded; break;
      case ScanType.wifi: icon = Icons.wifi_rounded; break;
      case ScanType.contact: icon = Icons.person_rounded; break;
      case ScanType.sms: icon = Icons.sms_rounded; break;
      case ScanType.geo: icon = Icons.location_on_rounded; break;
      default: icon = Icons.text_snippet_rounded;
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTypeSelected(type);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        width: 86,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.3) : Theme.of(context).dividerColor,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textDimmed,
                size: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textDimmed,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
