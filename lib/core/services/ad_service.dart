import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  // Test Ad Units for development
  static String get bannerAdUnitId => kDebugMode
      ? (Platform.isAndroid ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-3940256099942544/2934735716')
      : 'ca-app-pub-1506704627672992/1367949453';

  static String get nativeAdUnitId => kDebugMode
      ? (Platform.isAndroid ? 'ca-app-pub-3940256099942544/2247696110' : 'ca-app-pub-3940256099942544/3986624511')
      : 'ca-app-pub-1506704627672992/4618997007';

  static String get appOpenAdUnitId => kDebugMode
      ? (Platform.isAndroid ? 'ca-app-pub-3940256099942544/9257395921' : 'ca-app-pub-3940256099942544/5575463023')
      : 'ca-app-pub-1506704627672992/1140451840';

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  DateTime? _appOpenLoadTime;

  Future<void> init() async {
    await MobileAds.instance.initialize();
  }

  /// App Open Ad Logic
  void loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  bool get _isAppOpenAdAvailable => _appOpenAd != null && _appOpenLoadTime != null && DateTime.now().difference(_appOpenLoadTime!).inHours < 4;

  void showAppOpenAdIfAvailable() {
    if (_isShowingAd) return;
    if (!_isAppOpenAdAvailable) {
      loadAppOpenAd();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => _isShowingAd = true,
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
    );
    _appOpenAd!.show();
  }
}
