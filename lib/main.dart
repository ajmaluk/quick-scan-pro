import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:quickscan_pro/app.dart';
import 'package:quickscan_pro/data/local/hive_service.dart';
import 'package:quickscan_pro/core/services/notification_service.dart';
import 'package:quickscan_pro/core/services/ad_service.dart';

/// The main entry point of the QuickScan application.
void main() async {
  // Ensure Flutter bindings are initialized before any async work
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  // Keep the native splash screen visible during initialization
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize local database (Hive)
  await HiveService.init();

  // Initialize local notification service
  await NotificationService.init();

  // Initialize AdMob
  final adService = AdService();
  await adService.init();
  adService.loadAppOpenAd();

  // Handle App Open Ad on Resume
  WidgetsBinding.instance.addObserver(_AppOpenAdObserver(adService));

  runApp(
    const ProviderScope(
      child: QuickScanApp(),
    ),
  );
  
  // Initialization complete, dismiss the splash screen
  FlutterNativeSplash.remove();
}

class _AppOpenAdObserver extends WidgetsBindingObserver {
  final AdService _adService;
  _AppOpenAdObserver(this._adService);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _adService.showAppOpenAdIfAvailable();
    }
  }
}
