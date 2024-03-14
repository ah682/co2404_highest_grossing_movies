import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'enter_name.dart'; // Import the 'enter_name.dart' for navigation to the name entry screen

void main() {
  runApp(MaterialApp(home: IntroScreen())); // Entry point of the application
}

// The IntroScreen widget is the first screen users will see when they open the app.
class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Scaffold provides the structure for the intro screen layout.
    return Scaffold(
      // AppBar is used here to display the title of the screen and a settings button.
      appBar: AppBar(
        // IconButton used to navigate to the settings page when pressed.
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            // Push a new route (SettingsPage) onto the navigation stack when the settings icon is pressed.
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
        ),
        title: Text('IMDB Movie Trivia'), // Title of the AppBar.
      ),
      // Center widget is used to center the contents on the screen.
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0), // Padding around the container.
          child: Column(
            // Column widget is used to layout widgets vertically.
            mainAxisAlignment: MainAxisAlignment
                .center, // Centers the Column widget vertically.
            crossAxisAlignment: CrossAxisAlignment
                .center, // Centers the Column widget horizontally.
            children: <Widget>[
              Image.asset(
                'lib/assets/images/dune.jpg', // Image displayed at the top of the screen.
                height: 200.0, // Sets the height of the image.
              ),
              SizedBox(
                  height: 24.0), // Provides spacing between image and text.
              Text(
                // Description text for the trivia app.
                'Top Grossing Movies: Ultimate IMDB Trivia Companion\n\n'
                'Test your knowledge on top-grossing movies and climb the leaderboard with every correct answer',
                textAlign: TextAlign.center, // Centers the text.
                style: TextStyle(
                  fontSize: 16.0, // Sets the font size of the text.
                ),
              ),
              SizedBox(
                  height: 32.0), // Provides spacing between text and button.
              ElevatedButton(
                // Start button for the trivia app.
                onPressed: () {
                  // Navigates to the EnterNameScreen when the button is pressed.
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => EnterNameScreen(score: 0)),
                  );
                },
                child:
                    Text('Start Trivia App'), // Text displayed on the button.
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 16.0), // Sets the padding inside the button.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30.0), // Rounded corners of the button.
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
