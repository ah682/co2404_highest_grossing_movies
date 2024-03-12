import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'trivia_question_screen.dart'; // Adjust if necessary to match your file path

class EnterNameScreen extends StatefulWidget {
  final int score;

  const EnterNameScreen({Key? key, required this.score}) : super(key: key);

  @override
  _EnterNameScreenState createState() => _EnterNameScreenState();
}

class _EnterNameScreenState extends State<EnterNameScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _saveNameAndScoreAndRestartGame() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> scores = prefs.getStringList('highScores') ?? [];

    // Combine the user's name and score into a single string
    String combinedScore = '${_nameController.text}: ${widget.score}';

    // Add the new combined score to the list of scores
    scores.add(combinedScore);

    // You might want to limit the size of the scores list to keep the top N scores
    // scores = scores.take(N).toList();

    // Save the updated list back to SharedPreferences
    await prefs.setStringList('highScores', scores);

    // Navigate to the TriviaGame screen and remove all routes until there
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => TriviaGame()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Your Name'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNameAndScoreAndRestartGame,
              child: Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
