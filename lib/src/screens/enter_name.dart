import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'trivia_question_screen.dart'; // Ensure the import path matches the file location

// EnterNameScreen is a StatefulWidget that prompts users to enter their name before starting the game.
class EnterNameScreen extends StatefulWidget {
  final int
      score; // Holds the score, passed to this screen from the previous screen.

  // Constructor with required score parameter.
  const EnterNameScreen({Key? key, required this.score}) : super(key: key);

  @override
  _EnterNameScreenState createState() => _EnterNameScreenState();
}

// The state for EnterNameScreen where the logic and UI for user name entry is defined.
class _EnterNameScreenState extends State<EnterNameScreen> {
  // TextEditingController is used to read and control the text field input.
  final TextEditingController _nameController = TextEditingController();

  // Method to save the entered name to SharedPreferences and navigate to the TriviaGame screen.
  void _saveNameAndScoreAndRestartGame() async {
    // Retrieve the SharedPreferences instance.
    final prefs = await SharedPreferences.getInstance();
    // Save the entered name with the 'username' key.
    await prefs.setString('username', _nameController.text);

    // Replace the current route with the TriviaGame route, effectively restarting the game.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => TriviaGame()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the structure of the screen.
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Your Name'), // Title for the AppBar.
      ),
      // Padding adds space around the child Column.
      body: Padding(
        padding: EdgeInsets.all(16.0),
        // Column lays out its children vertically and centers them.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TextField allows the user to input text.
            TextField(
              controller:
                  _nameController, // Connects the text field to the controller.
              decoration: InputDecoration(
                labelText: 'Name', // Label shown inside the text field.
                border:
                    OutlineInputBorder(), // Adds a border around the text field.
              ),
            ),
            SizedBox(
                height: 20), // Space between the text field and the button.
            // ElevatedButton triggers the save and restart game process.
            ElevatedButton(
              onPressed: _saveNameAndScoreAndRestartGame,
              child: Text('Start Game'), // Text displayed on the button.
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController
        .dispose(); // Disposes the controller when the widget is removed from the widget tree.
    super.dispose();
  }
}
