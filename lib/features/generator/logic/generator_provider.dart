import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickscan_pro/core/utils/content_analyzer.dart';

/// A provider that manages the QR generator state.
final generatorProvider =
    StateNotifierProvider<GeneratorNotifier, GeneratorState>((ref) {
  return GeneratorNotifier();
});

/// Represents the current state of the QR generator.
class GeneratorState {
  final ScanType type;
  final String content;
  final Color foregroundColor;
  final Color backgroundColor;
  final QrEyeShape eyeShape;
  final QrDataModuleShape dataModuleShape;

  GeneratorState({
    this.type = ScanType.text,
    this.content = '',
    this.foregroundColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.eyeShape = QrEyeShape.square,
    this.dataModuleShape = QrDataModuleShape.square,
  });

  Map<String, dynamic> toJson() => {
        'type': type.index,
        'content': content,
        'foregroundColor': foregroundColor.toARGB32(),
        'backgroundColor': backgroundColor.toARGB32(),
        'eyeShape': eyeShape.index,
        'dataModuleShape': dataModuleShape.index,
      };

  factory GeneratorState.fromJson(Map<String, dynamic> json) => GeneratorState(
        type: ScanType.values[json['type'] as int? ?? 0],
        content: json['content'] as String? ?? '',
        foregroundColor: Color(json['foregroundColor'] as int? ?? Colors.black.toARGB32()),
        backgroundColor: Color(json['backgroundColor'] as int? ?? Colors.white.toARGB32()),
        eyeShape: QrEyeShape.values[json['eyeShape'] as int? ?? 0],
        dataModuleShape: QrDataModuleShape.values[json['dataModuleShape'] as int? ?? 0],
      );

  GeneratorState copyWith({
    ScanType? type,
    String? content,
    Color? foregroundColor,
    Color? backgroundColor,
    QrEyeShape? eyeShape,
    QrDataModuleShape? dataModuleShape,
  }) {
    return GeneratorState(
      type: type ?? this.type,
      content: content ?? this.content,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      eyeShape: eyeShape ?? this.eyeShape,
      dataModuleShape: dataModuleShape ?? this.dataModuleShape,
    );
  }
}

/// A StateNotifier that handles the configuration and updates for QR code generation.
class GeneratorNotifier extends StateNotifier<GeneratorState> {
  static const _prefKey = 'qr_generator_state';

  GeneratorNotifier() : super(GeneratorState()) {
    _loadState();
  }

  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_prefKey);
      if (jsonStr != null) {
        state = GeneratorState.fromJson(json.decode(jsonStr) as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error loading generator state: $e');
    }
  }

  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, json.encode(state.toJson()));
    } catch (e) {
      debugPrint('Error saving generator state: $e');
    }
  }

  /// Sets the type of content for the QR code (URL, Email, etc.).
  void setType(ScanType type) {
    state = state.copyWith(type: type);
    _saveState();
  }

  /// Sets the raw content string for the QR code.
  void setContent(String content) {
    state = state.copyWith(content: content);
    _saveState();
  }

  /// Sets the foreground color of the QR code modules.
  void setForegroundColor(Color color) {
    state = state.copyWith(foregroundColor: color);
    _saveState();
  }

  /// Sets the background color of the QR code.
  void setBackgroundColor(Color color) {
    state = state.copyWith(backgroundColor: color);
    _saveState();
  }

  /// Sets the shape of the QR code eyes (corner squares).
  void setEyeShape(QrEyeShape shape) {
    state = state.copyWith(eyeShape: shape);
    _saveState();
  }

  /// Sets the shape of the internal QR code data modules.
  void setDataModuleShape(QrDataModuleShape shape) {
    state = state.copyWith(dataModuleShape: shape);
    _saveState();
  }
}
