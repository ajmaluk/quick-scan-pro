import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickscan_pro/core/theme/app_theme.dart';
import 'package:quickscan_pro/features/generator/presentation/screens/qr_generator_screen.dart';
import 'package:quickscan_pro/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:quickscan_pro/features/settings/presentation/screens/settings_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> pumpForGolden(WidgetTester tester, Widget child) async {
    await tester.binding.setSurfaceSize(const Size(412, 915));
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          home: child,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
  }

  testWidgets('Onboarding screen golden', (tester) async {
    await pumpForGolden(tester, const OnboardingScreen());
    await expectLater(
      find.byType(OnboardingScreen),
      matchesGoldenFile('goldens/onboarding_screen.png'),
    );
  });

  testWidgets('Settings screen golden', (tester) async {
    await pumpForGolden(tester, const SettingsScreen());
    await expectLater(
      find.byType(SettingsScreen),
      matchesGoldenFile('goldens/settings_screen.png'),
    );
  });

  testWidgets('Generator screen empty state golden', (tester) async {
    await pumpForGolden(tester, const QRGeneratorScreen());
    await expectLater(
      find.byType(QRGeneratorScreen),
      matchesGoldenFile('goldens/generator_screen_empty.png'),
    );
  });
}
