import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  const PermissionService._();

  static bool isGranted(PermissionStatus status) {
    return status == PermissionStatus.granted || status == PermissionStatus.limited;
  }

  static bool isBlocked(PermissionStatus status) {
    return status == PermissionStatus.permanentlyDenied || status == PermissionStatus.restricted;
  }

  static Future<PermissionStatus> requestCamera({
    Future<PermissionStatus> Function()? requestOverride,
  }) {
    return requestOverride?.call() ?? Permission.camera.request();
  }

  static Future<PermissionStatus> requestPhotosAddOnly({
    Future<PermissionStatus> Function()? requestOverride,
  }) {
    return requestOverride?.call() ?? Permission.photosAddOnly.request();
  }

  static Future<bool> openSettings({
    Future<bool> Function()? openAppSettingsOverride,
  }) {
    return openAppSettingsOverride?.call() ?? openAppSettings();
  }
}
