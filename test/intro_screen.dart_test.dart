import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:co2404_highest_grossing_movies/src/screens/intro_screen.dart';
import 'package:co2404_highest_grossing_movies/src/screens/settings_page.dart';
import 'package:co2404_highest_grossing_movies/src/screens/enter_name.dart';

void main() {
  testWidgets('IntroScreen UI and Navigation Tests',
      (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(MaterialApp(home: IntroScreen()));

    // Verify that certain texts are found
    expect(find.text('IMDB Movie Trivia'), findsOneWidget);
    expect(find.text('Start Trivia App'), findsOneWidget);

    // Verify that an image is displayed
    expect(find.byType(Image), findsOneWidget);

    // Tap on the settings icon and verify navigation to the SettingsPage
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle(); // Wait for the navigation animation
    expect(find.byType(SettingsPage), findsOneWidget);

    // Go back to the intro screen
    await tester.pageBack();
    await tester
        .pumpAndSettle(); // The tester.pageBack() method should be awaited

    // Tap on the 'Start Trivia App' button and verify navigation to the EnterNameScreen
    await tester.tap(find.text('Start Trivia App'));
    await tester.pumpAndSettle(); // Wait for the navigation animation
    expect(find.byType(EnterNameScreen), findsOneWidget);
  });
}
