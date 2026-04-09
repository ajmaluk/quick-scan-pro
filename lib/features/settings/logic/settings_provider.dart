import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickscan_pro/core/constants/app_constants.dart';
import 'package:quickscan_pro/core/services/notification_service.dart';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

class SettingsState {
  final bool isVibrationEnabled;
  final bool isSoundEnabled;
  final bool isNotificationsEnabled;
  final ThemeMode themeMode;

  SettingsState({
    this.isVibrationEnabled = true,
    this.isSoundEnabled = true,
    this.isNotificationsEnabled = true,
    this.themeMode = ThemeMode.system,
  });

  SettingsState copyWith({
    bool? isVibrationEnabled,
    bool? isSoundEnabled,
    bool? isNotificationsEnabled,
    ThemeMode? themeMode,
  }) {
    return SettingsState(
      isVibrationEnabled: isVibrationEnabled ?? this.isVibrationEnabled,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      isNotificationsEnabled:
          isNotificationsEnabled ?? this.isNotificationsEnabled,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(AppConstants.themeModeKey) ?? 0;

    state = state.copyWith(
      isVibrationEnabled:
          prefs.getBool(AppConstants.vibrationEnabledKey) ?? true,
      isSoundEnabled: prefs.getBool(AppConstants.soundEnabledKey) ?? true,
      isNotificationsEnabled: prefs.getBool('notifications_enabled') ?? true,
      themeMode: ThemeMode.values[themeIndex],
    );
  }

  Future<void> toggleVibration(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.vibrationEnabledKey, value);
    state = state.copyWith(isVibrationEnabled: value);
  }

  Future<void> toggleSound(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.soundEnabledKey, value);
    state = state.copyWith(isSoundEnabled: value);
  }

  Future<void> toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value) {
      final granted = await NotificationService.requestPermission();
      if (!granted) {
        await prefs.setBool('notifications_enabled', false);
        state = state.copyWith(isNotificationsEnabled: false);
        return;
      }

      await prefs.setBool('notifications_enabled', true);
      state = state.copyWith(isNotificationsEnabled: true);
      await NotificationService.scheduleDailyNotification();
      return;
    }

    await prefs.setBool('notifications_enabled', false);
    state = state.copyWith(isNotificationsEnabled: false);
    await NotificationService.cancelAll();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.themeModeKey, mode.index);
    state = state.copyWith(themeMode: mode);
  }
}
