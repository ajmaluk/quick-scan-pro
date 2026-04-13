import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quickscan_pro/features/batch_scan/presentation/screens/batch_scanner_screen.dart';
import 'package:quickscan_pro/features/home/presentation/screens/home_screen.dart';
import 'package:quickscan_pro/features/scanner/presentation/screens/scanner_screen.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

enum NotificationTargetType {
  dailyReminder,
  campaignReminder,
  batchTip,
}

/// A service class that manages local notifications for user engagement.
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static const String scannerDeepLinkPayload = 'open_scanner';
  static const String historyDeepLinkPayload = 'open_history';
  static const String batchDeepLinkPayload = 'open_batch_scan';
  static GlobalKey<NavigatorState>? _navigatorKey;
  static String? _pendingDeepLinkPayload;
  static bool _isHandlingDeepLink = false;
  static const List<String> _supportedPayloads = <String>[
    scannerDeepLinkPayload,
    historyDeepLinkPayload,
    batchDeepLinkPayload,
  ];

  static void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  static String? consumePendingDeepLinkPayload() {
    final payload = _pendingDeepLinkPayload;
    _pendingDeepLinkPayload = null;
    return payload;
  }

  static bool handleDeepLinkPayload(String? payload) {
    if (payload == null || !_supportedPayloads.contains(payload)) {
      return false;
    }

    switch (payload) {
      case scannerDeepLinkPayload:
        _openScannerScreen();
        return true;
      case historyDeepLinkPayload:
        _openHistoryTab();
        return true;
      case batchDeepLinkPayload:
        _openBatchScannerScreen();
        return true;
      default:
        return false;
    }
  }

  /// Maps business notification categories to concrete deep-link payloads.
  static String payloadForType(NotificationTargetType type) {
    switch (type) {
      case NotificationTargetType.dailyReminder:
        return historyDeepLinkPayload;
      case NotificationTargetType.campaignReminder:
        return scannerDeepLinkPayload;
      case NotificationTargetType.batchTip:
        return batchDeepLinkPayload;
    }
  }

  static String _resolveDeepLinkPayload({
    String? deepLinkPayload,
    NotificationTargetType? notificationType,
  }) {
    if (notificationType != null) {
      return payloadForType(notificationType);
    }

    if (deepLinkPayload != null && _supportedPayloads.contains(deepLinkPayload)) {
      return deepLinkPayload;
    }

    return _pickRandomDeepLinkPayload();
  }

  static String _pickRandomDeepLinkPayload() {
    return _supportedPayloads[Random().nextInt(_supportedPayloads.length)];
  }

  /// List of engaging messages to show to the user.
  static const List<String> engagingMessages = [
    "Scan beautifully. Move faster. ✨",
    "Your next scan, refined and ready. 💎",
    "One tap to instant clarity. ⚡",
    "Turn any code into action, elegantly. 🚀",
    "Stay in flow. Scan, save, continue. 🎯",
    "Fast scanning, clean experience. ✨",
    "Clean results. Zero friction. 🤍",
    "A smarter way to capture every code. 🔍",
  ];

  /// Initializes the notification service and sets up channels for Android and iOS.
  static Future<void> init() async {
    try {
      tz.initializeTimeZones();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _handleNotificationResponse,
      );

      final launchDetails = await _notificationsPlugin.getNotificationAppLaunchDetails();
      if (launchDetails?.didNotificationLaunchApp ?? false) {
        final payload = launchDetails?.notificationResponse?.payload;
        if (payload != null && _supportedPayloads.contains(payload)) {
          _pendingDeepLinkPayload = payload;
        }
      }
    } catch (e) {
      debugPrint('Notification initialization error: $e');
    }
  }

  static void _handleNotificationResponse(NotificationResponse response) {
    handleDeepLinkPayload(response.payload);
  }

  static void _openScannerScreen() {
    if (_isHandlingDeepLink) return;

    final navigator = _navigatorKey?.currentState;
    if (navigator == null) {
      _pendingDeepLinkPayload = scannerDeepLinkPayload;
      return;
    }

    _isHandlingDeepLink = true;
    navigator.push(
      MaterialPageRoute<void>(builder: (_) => const ScannerScreen()),
    ).whenComplete(() {
      _isHandlingDeepLink = false;
    });
  }

  static void _openHistoryTab() {
    if (_isHandlingDeepLink) return;

    final navigator = _navigatorKey?.currentState;
    if (navigator == null) {
      _pendingDeepLinkPayload = historyDeepLinkPayload;
      return;
    }

    _isHandlingDeepLink = true;
    navigator.push(
      MaterialPageRoute<void>(builder: (_) => const HomeScreen(initialTabIndex: 1)),
    ).whenComplete(() {
      _isHandlingDeepLink = false;
    });
  }

  static void _openBatchScannerScreen() {
    if (_isHandlingDeepLink) return;

    final navigator = _navigatorKey?.currentState;
    if (navigator == null) {
      _pendingDeepLinkPayload = batchDeepLinkPayload;
      return;
    }

    _isHandlingDeepLink = true;
    navigator.push(
      MaterialPageRoute<void>(builder: (_) => const BatchScannerScreen()),
    ).whenComplete(() {
      _isHandlingDeepLink = false;
    });
  }

  /// Requests notification permission on supported platforms.
  static Future<bool> requestPermission() async {
    try {
      if (kIsWeb) {
        return true;
      }

      final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      final androidGranted = await androidPlugin?.requestNotificationsPermission();

      final iosPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      final macosPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>();
      final iosGranted = await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);
      final macosGranted = await macosPlugin?.requestPermissions(alert: true, badge: true, sound: true);

      if (defaultTargetPlatform == TargetPlatform.android) {
        return androidGranted ?? false;
      }

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return iosGranted ?? false;
      }

      if (defaultTargetPlatform == TargetPlatform.macOS) {
        return macosGranted ?? false;
      }

      return true;
    } catch (e) {
      debugPrint('Notification permission error: $e');
      return false;
    }
  }

  /// Displays a random engaging notification immediately.
  static Future<void> showRandomEngagingNotification({
    String? deepLinkPayload,
    NotificationTargetType? notificationType,
  }) async {
    try {
      final granted = await requestPermission();
      if (!granted) return;

      final random = Random();
      final message = engagingMessages[random.nextInt(engagingMessages.length)];
      final payload = _resolveDeepLinkPayload(
        deepLinkPayload: deepLinkPayload,
        notificationType: notificationType,
      );

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'quickscan_tips_channel',
        'Feature Tips',
        channelDescription: 'Tips and reminders for scan features',
        importance: Importance.low,
        priority: Priority.low,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      );

      await _notificationsPlugin.show(
        0,
        'QuickScan',
        message,
        notificationDetails,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  /// Schedules a daily notification with a random engaging message.
  static Future<void> scheduleDailyNotification({
    String? deepLinkPayload,
    NotificationTargetType notificationType = NotificationTargetType.dailyReminder,
  }) async {
    try {
      final granted = await requestPermission();
      if (!granted) return;

      final payload = _resolveDeepLinkPayload(
        deepLinkPayload: deepLinkPayload,
        notificationType: notificationType,
      );

      await _notificationsPlugin.zonedSchedule(
        1,
        'QuickScan',
        engagingMessages[Random().nextInt(engagingMessages.length)],
        tz.TZDateTime.now(tz.local).add(const Duration(hours: 24)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'quickscan_daily_channel',
            'Daily Reminder',
            channelDescription: 'Daily engaging message',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error scheduling daily notification: $e');
    }
  }

  /// Cancels all pending notifications.
  static Future<void> cancelAll() async {
    try {
      await _notificationsPlugin.cancelAll();
    } catch (e) {
      debugPrint('Error cancelling notifications: $e');
    }
  }
}
