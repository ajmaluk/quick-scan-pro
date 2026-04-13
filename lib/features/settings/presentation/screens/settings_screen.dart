import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickscan_pro/core/constants/app_constants.dart';
import 'package:quickscan_pro/core/navigation/shared_axis_route.dart';
import 'package:quickscan_pro/core/theme/colors.dart';
import 'package:quickscan_pro/core/theme/text_styles.dart';
import 'package:quickscan_pro/features/settings/logic/settings_provider.dart';
import 'package:quickscan_pro/features/settings/presentation/screens/about_screen.dart';
import 'package:quickscan_pro/features/settings/presentation/screens/help_screen.dart';
import 'package:quickscan_pro/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:quickscan_pro/features/settings/presentation/screens/terms_conditions_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final bottomSafePadding = MediaQuery.of(context).padding.bottom + 100;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildGlassHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(24, 12, 24, bottomSafePadding),
              children: [
                _buildHeroSummary(settings).animate().fade(duration: 400.ms).slideY(begin: 0.05, end: 0),
                const SizedBox(height: 32),
                _buildSectionHeader('Appearance'),
                _buildThemeDropdown(context, settings.themeMode, (mode) => settingsNotifier.setThemeMode(mode!)),
                const SizedBox(height: 24),
                _buildSectionHeader('Preferences'),
                _buildSwitchTile(context, icon: Icons.vibration_rounded, title: 'Vibration Feedback', value: settings.isVibrationEnabled, onChanged: (val) => settingsNotifier.toggleVibration(val)),
                _buildSwitchTile(context, icon: Icons.volume_up_rounded, title: 'Sound Effects', value: settings.isSoundEnabled, onChanged: (val) => settingsNotifier.toggleSound(val)),
                _buildSwitchTile(context, icon: Icons.notifications_active_rounded, title: 'Smart Notifications', value: settings.isNotificationsEnabled, onChanged: (val) => settingsNotifier.toggleNotifications(val)),
                const SizedBox(height: 24),
                _buildSectionHeader('Support & Legal'),
                _buildListTile(context, icon: Icons.info_outline_rounded, title: 'About QuickScan', onTap: () => Navigator.of(context).push(SharedAxisPageRoute(page: const AboutScreen(), transitionType: SharedAxisTransitionType.horizontal))),
                _buildListTile(context, icon: Icons.help_outline_rounded, title: 'Help & Support', onTap: () => Navigator.of(context).push(SharedAxisPageRoute(page: const HelpScreen(), transitionType: SharedAxisTransitionType.horizontal))),
                _buildListTile(context, icon: Icons.privacy_tip_outlined, title: 'Privacy Policy', onTap: () => Navigator.of(context).push(SharedAxisPageRoute(page: const PrivacyPolicyScreen(), transitionType: SharedAxisTransitionType.vertical))),
                _buildListTile(context, icon: Icons.gavel_rounded, title: 'Terms of Service', onTap: () => Navigator.of(context).push(SharedAxisPageRoute(page: const TermsConditionsScreen(), transitionType: SharedAxisTransitionType.vertical))),
                const SizedBox(height: 24),
                _buildSectionHeader('System'),
                _buildListTile(context, icon: Icons.refresh_rounded, title: 'Reset Experience', color: AppColors.warning, onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool(AppConstants.isFirstLaunchKey, true);
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Onboarding reset successfully')));
                }),
                _buildListTile(context, icon: Icons.share_rounded, title: 'Share with Friends', onTap: () => Share.share('QuickScan - QR & Barcode Reader: https://www.uthakkan.in')),
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Text('QUICKSCAN PRO', style: AppTextStyles.labelMedium.copyWith(letterSpacing: 2, color: AppColors.textDimmed)),
                      const SizedBox(height: 6),
                      Text('Version ${AppConstants.version}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textDimmed.withValues(alpha: 0.5))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Settings', style: AppTextStyles.h2),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(title.toUpperCase(), style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildHeroSummary(SettingsState settings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('App Experience', style: AppTextStyles.h3.copyWith(color: Colors.white)),
                Text(
                  'Optimized for speed & precision',
                  style: AppTextStyles.labelSmall.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeDropdown(BuildContext context, ThemeMode themeMode, void Function(ThemeMode?) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: const Icon(Icons.palette_rounded, color: AppColors.primary, size: 22),
        title: Text('Appearance', style: AppTextStyles.labelMedium.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        trailing: DropdownButtonHideUnderline(
          child: DropdownButton<ThemeMode>(
            value: themeMode,
            onChanged: (val) { HapticFeedback.selectionClick(); onChanged(val); },
            // Theme selection dropdown
            // Backdrop Blur for a refined look
            dropdownColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            items: [
              DropdownMenuItem(value: ThemeMode.system, child: Text('System', style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurface))),
              DropdownMenuItem(value: ThemeMode.light, child: Text('Light', style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurface))),
              DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark', style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurface))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(BuildContext context, {required IconData icon, required String title, required bool value, required Function(bool) onChanged}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Icon(icon, color: AppColors.primary, size: 22),
        title: Text(title, style: AppTextStyles.labelMedium.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        trailing: Switch.adaptive(
          value: value,
          activeThumbColor: AppColors.primary,
          onChanged: (val) { HapticFeedback.selectionClick(); onChanged(val); },
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap, Color? color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: ListTile(
        onTap: () { HapticFeedback.lightImpact(); onTap(); },
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Icon(icon, color: color ?? AppColors.textDimmed, size: 22),
        title: Text(title, style: AppTextStyles.labelMedium.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textDimmed.withValues(alpha: 0.3)),
      ),
    );
  }
}
