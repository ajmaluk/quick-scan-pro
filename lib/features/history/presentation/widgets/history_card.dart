import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:quickscan_pro/core/theme/colors.dart';
import 'package:quickscan_pro/core/theme/text_styles.dart';
import 'package:quickscan_pro/core/widgets/press_scale.dart';
import 'package:quickscan_pro/core/utils/content_analyzer.dart';
import 'package:quickscan_pro/data/models/scan_history.dart';

class HistoryCard extends StatelessWidget {
  final ScanHistory scan;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onDelete;

  const HistoryCard({
    super.key,
    required this.scan,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final scanType = ContentAnalyzer.analyze(scan.content);
    final typeName = ContentAnalyzer.getTypeName(scanType);
    final dateStr = DateFormat('MMM d, h:mm a').format(scan.timestamp);

    return Dismissible(
      key: Key(scan.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 28),
      ),
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        onDelete();
      },
      child: PressScale(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            children: [
              _buildIcon(scanType),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(typeName, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                        Text(dateStr, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textDimmed)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scan.content,
                      style: AppTextStyles.bodyMedium.copyWith(color: Theme.of(context).colorScheme.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  onFavoriteToggle();
                },
                icon: Icon(
                  scan.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                  color: scan.isFavorite ? Colors.amber : AppColors.textDimmed,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(ScanType type) {
    IconData icon;
    Color color;

    switch (type) {
      case ScanType.url: icon = Icons.link_rounded; color = AppColors.primary; break;
      case ScanType.wifi: icon = Icons.wifi_rounded; color = AppColors.success; break;
      case ScanType.contact: icon = Icons.person_rounded; color = AppColors.secondary; break;
      case ScanType.email: icon = Icons.email_rounded; color = AppColors.warning; break;
      case ScanType.phone: icon = Icons.phone_rounded; color = AppColors.info; break;
      default: icon = Icons.text_snippet_rounded; color = AppColors.textDimmed;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
