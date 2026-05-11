import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quickscan_pro/core/theme/colors.dart';
import 'package:quickscan_pro/core/theme/text_styles.dart';
import 'package:quickscan_pro/core/theme/dimensions.dart';
import 'package:quickscan_pro/core/constants/app_constants.dart';
import 'package:quickscan_pro/core/constants/strings.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  Future<bool> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    return launchUrl(uri);
  }

  Future<void> _sendEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'contact.uthakkan@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'QuickScan Help & Support',
      }),
    );

    final messenger = ScaffoldMessenger.of(context);
    if (!await launchUrl(emailLaunchUri)) {
      if (!context.mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Unable to open your email app right now.')),
      );
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + 16;
    final bottomPadding = MediaQuery.of(context).padding.bottom + AppDimensions.lg;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).brightness == Brightness.dark
              ? AppColors.backgroundGradient
              : AppColors.lightBackgroundGradient,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppDimensions.lg,
            topPadding,
            AppDimensions.lg,
            bottomPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildHeaderSection(context),
              const SizedBox(height: 32),
              _buildContactSection(context),
              const SizedBox(height: 32),
              _buildLinkSection(context),
              const SizedBox(height: 48),
              _buildFooterSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: Theme.of(context).colorScheme.onSurface,
        ),
        const SizedBox(width: 8),
        Text(
          AppStrings.helpSupport,
          style: AppTextStyles.h2.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How can we help you?',
          style: AppTextStyles.h2.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'We are here to provide support and answer any questions you may have about QuickScan.',
          style: AppTextStyles.bodyMedium.copyWith(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardTheme.color?.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: ListTile(
        onTap: () => _sendEmail(context),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.email_rounded, color: AppColors.primary),
        ),
        title: Text(
          'Email Support',
          style: AppTextStyles.labelLarge.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          'contact.uthakkan@gmail.com',
          style: AppTextStyles.bodySmall.copyWith(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildLinkSection(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardTheme.color?.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: ListTile(
        onTap: () => _openLink(context, 'https://www.uthakkan.in/contact'),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.language_rounded, color: AppColors.secondary),
        ),
        title: Text(
          'Contact Page',
          style: AppTextStyles.labelLarge.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          'Visit our website for more details',
          style: AppTextStyles.bodySmall.copyWith(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        trailing: Icon(
          Icons.open_in_new_rounded,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          size: 20,
        ),
      ),
    );
  }

  Future<void> _openLink(BuildContext context, String url) async {
    final messenger = ScaffoldMessenger.of(context);
    final launched = await _launchUrl(url);
    if (!context.mounted) return;
    if (!launched) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Unable to open the page right now.')),
      );
    }
  }

  Widget _buildFooterSection(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.help_outline_rounded,
            size: 64,
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'QuickScan ${AppConstants.version}',
            style: AppTextStyles.bodySmall.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
