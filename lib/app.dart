import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickscan_pro/core/theme/app_theme.dart';
import 'package:quickscan_pro/core/services/notification_service.dart';
import 'package:quickscan_pro/features/onboarding/logic/onboarding_provider.dart';
import 'package:quickscan_pro/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:quickscan_pro/features/home/presentation/screens/home_screen.dart';
import 'package:quickscan_pro/features/settings/logic/settings_provider.dart';

/// The root widget of the QuickScan application.
/// 
/// It configures the app's theme, title, and initial route based on whether
/// it's the user's first time launching the app.
class QuickScanApp extends ConsumerStatefulWidget {
  const QuickScanApp({super.key});

  @override
  ConsumerState<QuickScanApp> createState() => _QuickScanAppState();
}

class _QuickScanAppState extends ConsumerState<QuickScanApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    NotificationService.setNavigatorKey(_navigatorKey);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pendingPayload = NotificationService.consumePendingDeepLinkPayload();
      NotificationService.handleDeepLinkPayload(pendingPayload);
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isFirstLaunch = ref.watch(onboardingProvider);

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'QuickScan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      home: isFirstLaunch ? const OnboardingScreen() : const HomeScreen(),
    );
  }
}
