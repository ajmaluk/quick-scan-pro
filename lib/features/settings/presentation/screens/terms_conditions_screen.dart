import 'package:flutter/material.dart';
import 'package:quickscan_pro/core/theme/colors.dart';
import 'package:quickscan_pro/core/theme/text_styles.dart';
import 'package:quickscan_pro/core/theme/dimensions.dart';

/// A screen that displays the Terms & Conditions for the QuickScan application.
class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).brightness == Brightness.dark
              ? AppColors.backgroundGradient
              : AppColors.lightBackgroundGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                context,
                'Introduction',
                'By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app.',
              ),
              _buildSection(
                context,
                'Proprietary Rights',
                'You’re not allowed to copy, or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages, or make derivative versions.',
              ),
              _buildSection(
                context,
                'Changes to the App',
                'Uthakkan is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason.',
              ),
              _buildSection(
                context,
                'Data Security',
                'The QuickScan app stores and processes personal data that you have provided to us, in order to provide our Service. It’s your responsibility to keep your phone and access to the app secure.',
              ),
              _buildSection(
                context,
                'Limitation of Liability',
                'We will not be liable for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app.',
              ),
              _buildSection(
                context,
                'Changes to These Terms',
                'We may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes.',
              ),
              _buildSection(
                context,
                'Contact Us',
                'If you have any questions or suggestions about our Terms and Conditions, do not hesitate to contact us at contact.uthakkan@gmail.com.',
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
