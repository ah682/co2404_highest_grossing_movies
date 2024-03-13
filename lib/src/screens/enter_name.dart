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
    String name = _nameController.text.trim();

    // Check if the name field is empty
    if (name.isEmpty) {
      _showSnackBar('Please enter your name to continue.');
      return; // Exit the function if the name field is empty
    }

    // Check if the name exceeds 65 characters
    if (name.length > 65) {
      _showSnackBar('The name cannot exceed 65 characters.');
      return; // Exit the function if the name is too long
    }

    final prefs = await SharedPreferences.getInstance();
    List<String> scores = prefs.getStringList('highScores') ?? [];

    // Combine the user's name and score into a single string
    String combinedScore = '$name: ${widget.score}';

    // Add the new combined score to the list of scores
    scores.add(combinedScore);

    // Save the updated list back to SharedPreferences
    await prefs.setStringList('highScores', scores);

    // Navigate to the TriviaGame screen and remove all routes until there
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => TriviaGame()),
      (Route<dynamic> route) => false,
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
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
              maxLength: 65, // Set the maxLength property to limit input
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                counterText: '', // Hide the counter underneath the TextField
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
