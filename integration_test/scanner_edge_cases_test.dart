import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickscan_pro/core/utils/action_url_builder.dart';
import 'package:quickscan_pro/core/utils/content_analyzer.dart';
import 'package:quickscan_pro/core/utils/scan_deduplicator.dart';
import 'package:quickscan_pro/features/scanner/presentation/screens/scanner_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Permission denied forever shows Open Settings action',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: ScannerScreen(
            permissionRequestOverride: () async => PermissionStatus.permanentlyDenied,
            openAppSettingsOverride: () async => true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Camera permission required'), findsOneWidget);
    expect(find.text('Open Settings'), findsOneWidget);
  });

  testWidgets('No camera available shows recovery UI', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: ScannerScreen(
            permissionRequestOverride: () async => PermissionStatus.granted,
            debugCameraErrorMessage: 'No camera available on this device',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No camera available on this device'), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);
  });

  testWidgets('Repeated same scans are throttled', (tester) async {
    final deduplicator = ScanDeduplicator(cooldown: const Duration(seconds: 2));
    final t0 = DateTime(2026, 3, 21, 10, 0, 0);

    expect(deduplicator.shouldProcess('hello', t0), isTrue);
    expect(deduplicator.shouldProcess('hello', t0.add(const Duration(milliseconds: 500))),
        isFalse);
    expect(deduplicator.shouldProcess('hello', t0.add(const Duration(seconds: 3))),
        isTrue);
    expect(deduplicator.shouldProcess('world', t0.add(const Duration(seconds: 3))),
        isTrue);
  });

  testWidgets('Malformed URL falls back safely to search', (tester) async {
    const malformed = 'ht!tp://%%bad-url';
    final primaryUri = ActionUrlBuilder.buildPrimaryUri(ScanType.url, malformed);
    final fallback = ActionUrlBuilder.buildSearchUri(malformed);

    expect(primaryUri, isNull);
    expect(fallback.toString(), contains('google.com/search?q='));
  });
}
