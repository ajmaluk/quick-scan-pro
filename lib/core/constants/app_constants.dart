class AppConstants {
  static const String appName = 'QuickScan';
  static const String packageName = 'com.quickscan.pro';
  static const String version = '1.0.0+1';
  
  // Storage Keys
  static const String hiveBoxName = 'scans_box';
  static const String settingsBoxName = 'settings_box';
  
  // Settings Keys
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String themeModeKey = 'theme_mode';
  static const String vibrationEnabledKey = 'vibration_enabled';
  static const String soundEnabledKey = 'sound_enabled';
  
  // Durations
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration scanCooldown = Duration(seconds: 2);
  
  // Animation Values
  static const double scannerLaserSweepDuration = 1000; // ms
}
