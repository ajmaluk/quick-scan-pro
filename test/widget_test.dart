import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickscan_pro/app.dart';
import 'package:quickscan_pro/core/constants/strings.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App boots and shows onboarding flow', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: QuickScanApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(AppStrings.skip), findsOneWidget);
    expect(find.text(AppStrings.next), findsOneWidget);
  });

  testWidgets('Onboarding next button moves to next page', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: QuickScanApp(),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.next));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.onboarding2Title), findsOneWidget);
  });
}
