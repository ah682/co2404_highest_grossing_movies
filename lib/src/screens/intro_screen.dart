import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'enter_name.dart'; // Ensure you've created this file and it's correctly referenced

void main() {
  runApp(MaterialApp(home: IntroScreen()));
}

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
        ),
        title: Text('IMDB Movie Trivia'),
      ),
      body: Center(
        // Add Center widget to enforce center alignment
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'lib/assets/images/dune.jpg',
                height: 200.0,
              ),
              SizedBox(height: 24.0),
              Text(
                'Top Grossing Movies: Ultimate IMDB Trivia Companion\n\n'
                'Test your knowledge on top-grossing movies and climb the leaderboard with every correct answer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => EnterNameScreen(score: 0)),
                  );
                },
                child: Text('Start Trivia App'),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
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
