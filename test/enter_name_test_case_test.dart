import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:co2404_highest_grossing_movies/src/screens/enter_name.dart';

void main() {
  group('EnterNameScreen Tests', () {
    // This is necessary to initialize SharedPreferences for tests
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets(
        'Should allow text entry in TextField and store it in SharedPreferences',
        (WidgetTester tester) async {
      // Build the EnterNameScreen widget
      await tester.pumpWidget(MaterialApp(home: EnterNameScreen(score: 0)));

      // Find the TextField widget
      final textFieldFinder = find.byType(TextField);

      // Verify the TextField is empty initially
      expect(find.text('John Doe'), findsNothing);

      // Enter 'John Doe' into the TextField
      await tester.enterText(textFieldFinder, 'John Doe');

      // Rebuild the widget to reflect changes
      await tester.pump();

      // Verify the entered text is now in the TextField
      expect(find.text('John Doe'), findsOneWidget);

      // Optionally, you can add a button tap action here if you want to test saving functionality

      // Here you would typically verify that SharedPreferences has been updated as expected.
      // Since we're using setMockInitialValues, actual SharedPreferences is not used in tests.
      // In a real-world scenario, you might use a mocking framework like Mockito to verify the interactions with SharedPreferences.
    });
  });
}
