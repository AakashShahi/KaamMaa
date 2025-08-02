import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaammaa/features/notiications/presentation/view/notification_view.dart';

void main() {
  // Helper function to pump the widget with necessary setup
  Future<void> pumpNotificationView(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CustomerNotificationView()),
    );
  }

  group('CustomerNotificationView', () {
    testWidgets('displays initial notifications correctly', (
      WidgetTester tester,
    ) async {
      // Act
      await pumpNotificationView(tester);

      // Assert
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Ram Thapa requested a job.'), findsOneWidget);
      expect(find.text('Worker accepted your job request.'), findsOneWidget);

      // Check that the "Clear All" button is visible
      expect(find.byIcon(Icons.delete_forever), findsOneWidget);

      // Check that the empty state message is not visible
      expect(find.text('No notifications'), findsNothing);
    });

    testWidgets(
      'removes a single notification when its clear button is tapped',
      (WidgetTester tester) async {
        // Arrange
        await pumpNotificationView(tester);

        // Verify the notification is present initially
        expect(find.text('Ram Thapa requested a job.'), findsOneWidget);

        // Act: Tap the 'clear' icon of the first ListTile
        await tester.tap(find.byIcon(Icons.clear).first);
        await tester.pump(); // Rebuild the widget after setState

        // Assert
        // The first notification should be gone
        expect(find.text('Ram Thapa requested a job.'), findsNothing);
        // The second one should still be there
        expect(find.text('Worker accepted your job request.'), findsOneWidget);
      },
    );

    testWidgets(
      'clears all notifications when the delete_forever icon is tapped',
      (WidgetTester tester) async {
        // Arrange
        await pumpNotificationView(tester);

        // Verify notifications are present initially
        expect(find.byType(ListTile), findsNWidgets(2));

        // Act
        await tester.tap(find.byIcon(Icons.delete_forever));
        await tester.pump(); // Rebuild the widget after setState

        // Assert
        // All ListTiles should be gone
        expect(find.byType(ListTile), findsNothing);
        // The empty state message should be visible
        expect(find.text('No notifications'), findsOneWidget);
        // The "Clear All" button in the AppBar should be gone
        expect(find.byIcon(Icons.delete_forever), findsNothing);
      },
    );
  });
}
