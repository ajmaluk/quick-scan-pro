import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// A service class that manages local notifications for user engagement.
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// List of engaging messages to show to the user.
  static const List<String> engagingMessages = [
    "Ready to scan something new today?",
    "Keep your digital life organized with QuickScan.",
    "Fast, secure, and reliable scanning at your fingertips.",
    "Share your contact details easily with a generated QR code.",
    "Did you know you can batch scan multiple items?",
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
      );
    } catch (e) {
      debugPrint('Notification initialization error: $e');
    }
  }

  /// Displays a random engaging notification immediately.
  static Future<void> showRandomEngagingNotification() async {
    try {
      final random = Random();
      final message = engagingMessages[random.nextInt(engagingMessages.length)];

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'quickscan_engaging_channel',
        'Engaging Notifications',
        channelDescription: 'Random messages to keep users engaged',
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
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  /// Schedules a daily notification with a random engaging message.
  static Future<void> scheduleDailyNotification() async {
    try {
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
