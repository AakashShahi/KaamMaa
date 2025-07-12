import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/features/onboarding/presentation/view/onboarding_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OnboardingView Widget Tests', () {
    testWidgets('displays onboarding screens with title and description', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: OnboardingView()));

      // Wait for Bloc to initialize
      await tester.pumpAndSettle();

      // Check that the first screen's title appears
      expect(find.text('Find Jobs or Hire Help — Locally'), findsOneWidget);
      expect(find.textContaining('KaamMaa connects'), findsOneWidget);

      // Check that 'Skip' and 'Next' buttons exist
      expect(find.text('Skip'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('pressing Skip navigates to last onboarding page', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: OnboardingView()));

      await tester.pumpAndSettle();

      // Tap on the Skip button
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      // The last page's title should now be visible
      expect(find.text('Reliable, Reviewed, and Local'), findsOneWidget);

      // And 'Get Started' button should be visible
      expect(find.text('Get Started'), findsOneWidget);
    });
  });
}
