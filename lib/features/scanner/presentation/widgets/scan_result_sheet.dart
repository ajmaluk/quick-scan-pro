import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickscan_pro/core/theme/colors.dart';
import 'package:quickscan_pro/core/theme/text_styles.dart';
import 'package:quickscan_pro/core/utils/action_url_builder.dart';
import 'package:quickscan_pro/core/utils/content_analyzer.dart';
import 'package:quickscan_pro/core/widgets/press_scale.dart';
import 'package:quickscan_pro/data/models/scan_history.dart';
import 'package:quickscan_pro/features/history/logic/history_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:quickscan_pro/core/constants/strings.dart';

class ScanResultSheet extends ConsumerStatefulWidget {
  final String content;
  final String format;

  const ScanResultSheet({
    super.key,
    required this.content,
    required this.format,
  });

  static void show(BuildContext context, String content, {String format = 'QR_CODE'}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ScanResultSheet(content: content, format: format),
    );
  }

  @override
  ConsumerState<ScanResultSheet> createState() => _ScanResultSheetState();
}

class _ScanResultSheetState extends ConsumerState<ScanResultSheet> {
  ScanHistory? _savedScan;

  @override
  void initState() {
    super.initState();
    _saveToHistory();
  }

  void _saveToHistory() {
    final type = ContentAnalyzer.analyze(widget.content);
    _savedScan = ScanHistory.create(
      content: widget.content,
      type: ContentAnalyzer.getTypeName(type).toLowerCase(),
      format: widget.format,
    );
    ref.read(historyProvider.notifier).addScan(_savedScan!);
  }

  void _toggleFavorite() {
    if (_savedScan != null) {
      ref.read(historyProvider.notifier).toggleFavoriteById(_savedScan!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(historyProvider).any((s) => s.content == widget.content && s.isFavorite);
    final type = ContentAnalyzer.analyze(widget.content);
    final typeName = ContentAnalyzer.getTypeName(type);
    final bottomSafePadding = MediaQuery.of(context).padding.bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomSafePadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _buildTypeIcon(type),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(typeName, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary), overflow: TextOverflow.ellipsis, maxLines: 1),
                            Text(widget.format, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textDimmed), overflow: TextOverflow.ellipsis, maxLines: 1),
                          ],
                        ),
                      ),
                      _buildFavoriteButton(isFavorite),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: type == ScanType.contact && widget.content.startsWith('BEGIN:VCARD')
                        ? _buildContactDetails(ActionUrlBuilder.parseVCard(widget.content))
                        : SelectableText(
                            widget.content,
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                  ),
                  const SizedBox(height: 32),
                  _buildActionRow(type),
                ],
              ),
            ),
          ),
      ),
    );
  }

  Widget _buildTypeIcon(ScanType type) {
    IconData icon;
    Color color;

    switch (type) {
      case ScanType.url: icon = Icons.link_rounded; color = AppColors.primary; break;
      case ScanType.wifi: icon = Icons.wifi_rounded; color = AppColors.success; break;
      case ScanType.contact: icon = Icons.person_rounded; color = AppColors.secondary; break;
      case ScanType.email: icon = Icons.email_rounded; color = AppColors.warning; break;
      case ScanType.phone: icon = Icons.phone_rounded; color = AppColors.info; break;
      case ScanType.geo: icon = Icons.location_on_rounded; color = AppColors.accent; break;
      case ScanType.upi: icon = Icons.account_balance_wallet_rounded; color = AppColors.success; break;
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

  Widget _buildFavoriteButton(bool isFavorite) {
    return PressScale(
      onTap: () {
        Vibrate.feedback(FeedbackType.selection);
        _toggleFavorite();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isFavorite ? Colors.red.withValues(alpha: 0.1) : Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
          color: isFavorite ? Colors.red : AppColors.textDimmed,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildActionRow(ScanType type) {
    return Row(
      children: [
        Expanded(
          child: PressScale(
            onTap: () => _performMainAction(type),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_getMainActionIcon(type), color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(_getMainActionLabel(type), style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _buildSmallIconAction(Icons.copy_rounded, _copyToClipboard),
        const SizedBox(width: 12),
        _buildSmallIconAction(Icons.share_rounded, _shareContent),
      ],
    );
  }

  Widget _buildSmallIconAction(IconData icon, VoidCallback onTap) {
    return PressScale(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 22),
      ),
    );
  }

  IconData _getMainActionIcon(ScanType type) {
    switch (type) {
      case ScanType.url: return Icons.open_in_browser_rounded;
      case ScanType.wifi: return Icons.wifi_password_rounded;
      case ScanType.contact: return Icons.person_add_rounded;
      case ScanType.email: return Icons.mail_outline_rounded;
      case ScanType.phone: return Icons.call_rounded;
      case ScanType.geo: return Icons.map_rounded;
      case ScanType.upi: return Icons.payment_rounded;
      default: return Icons.search_rounded;
    }
  }

  String _getMainActionLabel(ScanType type) {
    switch (type) {
      case ScanType.url: return 'Open Link';
      case ScanType.wifi: return 'Copy Password';
      case ScanType.contact: return 'Add Contact';
      case ScanType.email: return 'Send Email';
      case ScanType.phone: return 'Call Contact';
      case ScanType.geo: return 'View Map';
      case ScanType.upi: return 'Pay Now';
      default: return 'Search Web';
    }
  }

  Widget _buildContactDetails(Map<String, String> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data.containsKey('name')) _buildDetailItem(AppStrings.name, data['name']!, Icons.person_rounded),
        if (data.containsKey('phone')) _buildDetailItem(AppStrings.phone, data['phone']!, Icons.phone_rounded),
        if (data.containsKey('email')) _buildDetailItem(AppStrings.email, data['email']!, Icons.email_rounded),
        if (data.containsKey('org')) _buildDetailItem(AppStrings.organization, data['org']!, Icons.business_rounded),
        if (data.isEmpty)
          SelectableText(
            widget.content,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textDimmed)),
                SelectableText(value, style: AppTextStyles.bodyMedium.copyWith(color: Theme.of(context).colorScheme.onSurface)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _performMainAction(ScanType type) async {
    final content = widget.content.trim();
    Vibrate.feedback(FeedbackType.light);
    switch (type) {
      case ScanType.url:
      case ScanType.geo:
      case ScanType.phone:
      case ScanType.email:
      case ScanType.upi:
        final uri = ActionUrlBuilder.buildPrimaryUri(type, content);
        if (uri != null && await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: (type == ScanType.url) 
                ? LaunchMode.platformDefault 
                : LaunchMode.externalApplication,
          );
        } else {
          await launchUrl(ActionUrlBuilder.buildSearchUri(content));
        }
        break;
      case ScanType.wifi:
        _copyToClipboard();
        break;
      default:
        await launchUrl(ActionUrlBuilder.buildSearchUri(content));
    }
  }

  void _copyToClipboard() {
    Vibrate.feedback(FeedbackType.selection);
    Clipboard.setData(ClipboardData(text: widget.content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  void _shareContent() {
    Vibrate.feedback(FeedbackType.selection);
    Share.share(widget.content);
  }
}
