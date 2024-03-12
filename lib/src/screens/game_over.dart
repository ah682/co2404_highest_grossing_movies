import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'intro_screen.dart';

class GameOverScreen extends StatefulWidget {
  final int score;

  const GameOverScreen({Key? key, required this.score}) : super(key: key);

  @override
  _GameOverScreenState createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  List<String> highScores = [];

  @override
  void initState() {
    super.initState();
    _loadHighScores();
  }

  _loadHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    highScores = prefs.getStringList('highScores') ?? [];

    // Sort the scores in descending order based on the numeric value after the colon
    highScores.sort((a, b) {
      int scoreA = int.parse(a.split(":").last.trim());
      int scoreB = int.parse(b.split(":").last.trim());
      return scoreB.compareTo(scoreA);
    });

    // Keep only the top 5 scores
    if (highScores.length > 5) {
      highScores = highScores.sublist(0, 5);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Over'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Game Over\nYour Score: ${widget.score}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'High Scores',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...highScores.map((score) {
              return Text(score, style: TextStyle(fontSize: 18));
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => IntroScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('New Game'),
            ),
          ],
        ),
      ),
    );
  }
}
