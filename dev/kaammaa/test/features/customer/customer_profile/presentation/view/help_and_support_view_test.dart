import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view/help_and_support_view.dart'; // Adjust this import to your file's actual path

void main() {
  // Helper function to pump the widget with the necessary MaterialApp parent
  Future<void> pumpHelpSupportView(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HelpSupportView()));
  }

  group('HelpSupportView', () {
    testWidgets('renders AppBar and support text correctly', (
      WidgetTester tester,
    ) async {
      // Act
      await pumpHelpSupportView(tester);

      // Assert
      // Check for the AppBar title
      expect(find.text('Help & Support'), findsOneWidget);

      // Check for the main body text. We can use find.textContaining
      // to check for parts of the string, making the test more resilient
      // to minor text changes.
      expect(
        find.textContaining('support@kaammaa.com', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining('+977-9800000000', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining('9 AM to 6 PM', findRichText: true),
        findsOneWidget,
      );
    });
  });
}
