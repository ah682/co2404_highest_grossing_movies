import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'intro_screen.dart';

// GameOverScreen is a StatefulWidget that displays the final score and high scores when the game ends.
class GameOverScreen extends StatefulWidget {
  final int score; // The final score achieved by the player.

  // Constructor for GameOverScreen takes a required score parameter.
  const GameOverScreen({Key? key, required this.score}) : super(key: key);

  @override
  _GameOverScreenState createState() => _GameOverScreenState();
}

// State class for GameOverScreen.
class _GameOverScreenState extends State<GameOverScreen> {
  List<String> highScores = []; // A list to hold high score strings.

  @override
  void initState() {
    super.initState();
    _loadHighScores(); // Load high scores from SharedPreferences when the screen initializes.
  }

  // Method to load high scores from SharedPreferences.
  _loadHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    // Retrieve the list of high scores or initialize it as empty if not present.
    highScores = prefs.getStringList('highScores') ?? [];

    // Sort the scores in descending order based on the numeric value after the colon.
    highScores.sort((a, b) {
      int scoreA = int.parse(a.split(":").last.trim());
      int scoreB = int.parse(b.split(":").last.trim());
      return scoreB.compareTo(scoreA);
    });

    // Keep only the top 5 scores for display.
    if (highScores.length > 5) {
      highScores = highScores.sublist(0, 5);
    }

    // Trigger a rebuild of the widget to update the UI with the high scores.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the structure for the screen layout.
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Over'), // Title for the AppBar.
      ),
      // Center widget centers its children in the middle of the screen.
      body: Center(
        // Column widget is used to layout the children vertically.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text widget to display the 'Game Over' message and final score.
            Text(
              'Game Over\nYour Score: ${widget.score}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold, // Bold font for the game over text.
              ),
            ),
            SizedBox(height: 20), // Vertical space between text widgets.
            // Text widget to display the 'High Scores' heading.
            Text(
              'High Scores',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight
                      .bold), // Bold font for the high scores heading.
            ),
            // Map the highScores list to Text widgets and convert to a list.
            ...highScores.map((score) {
              return Text(score,
                  style: TextStyle(
                      fontSize: 18)); // Text style for each high score.
            }).toList(),
            SizedBox(height: 20), // Vertical space before the button.
            // ElevatedButton to start a new game.
            ElevatedButton(
              onPressed: () {
                // Navigate to the IntroScreen and remove all routes from the stack.
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => IntroScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('New Game'), // Text displayed on the button.
            ),
          ],
        ),
      ),
    );
  }
}
