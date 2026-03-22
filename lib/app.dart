import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickscan_pro/core/theme/app_theme.dart';
import 'package:quickscan_pro/features/onboarding/logic/onboarding_provider.dart';
import 'package:quickscan_pro/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:quickscan_pro/features/home/presentation/screens/home_screen.dart';
import 'package:quickscan_pro/features/settings/logic/settings_provider.dart';

/// The root widget of the QuickScan application.
/// 
/// It configures the app's theme, title, and initial route based on whether
/// it's the user's first time launching the app.
class QuickScanApp extends ConsumerWidget {
  const QuickScanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for theme and onboarding state changes
    final settings = ref.watch(settingsProvider);
    final isFirstLaunch = ref.watch(onboardingProvider);

    return MaterialApp(
      title: 'QuickScan',
      debugShowCheckedModeBanner: false,
      // Apply professional custom themes
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // Handle system/light/dark theme switching
      themeMode: settings.themeMode,
      // Determine the starting screen
      home: isFirstLaunch ? const OnboardingScreen() : const HomeScreen(),
    );
  }
}
