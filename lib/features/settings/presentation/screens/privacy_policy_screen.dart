import 'package:flutter/material.dart';
import 'package:quickscan_pro/core/theme/colors.dart';
import 'package:quickscan_pro/core/theme/text_styles.dart';
import 'package:quickscan_pro/core/theme/dimensions.dart';

/// A screen that displays the Privacy Policy for the QuickScan application.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
              _buildSection(
                context,
                'Introduction',
                'Your privacy is important to us. This Privacy Policy explains how QuickScan ("we", "us", or "our") collects, uses, and protects your information when you use our mobile application.',
              ),
              _buildSection(
                context,
                'Data Collection',
                'QuickScan is designed with privacy in mind. We do not collect, store, or transmit any personal data from your scans to our servers. All scan history and generated QR codes are stored locally on your device.',
              ),
              _buildSection(
                context,
                'Permissions',
                'To provide its core functionality, QuickScan requires access to your device\'s camera. This permission is used solely for scanning QR codes and barcodes. We do not use the camera for any other purpose.',
              ),
              _buildSection(
                context,
                'Third-Party Services',
                'QuickScan uses Google AdMob to display advertisements. AdMob may collect certain device identifiers and anonymized usage data to serve personalized ads. Please refer to Google\'s Privacy & Terms for more information.',
              ),
              _buildSection(
                context,
                'Updates to This Policy',
                'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.',
              ),
              _buildSection(
                context,
                'Contact Us',
                'If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at contact.uthakkan@gmail.com.',
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'Last Updated: March 21, 2026',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
          'Privacy Policy',
          style: AppTextStyles.h2.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
