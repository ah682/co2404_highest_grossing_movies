import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'trivia_question_screen.dart'; // Ensure the import path matches the file location
import 'package:cloud_firestore/cloud_firestore.dart';

class EnterNameScreen extends StatefulWidget {
  final int
      score; // Holds the score, passed to this screen from the previous screen.

  const EnterNameScreen({Key? key, required this.score}) : super(key: key);

  @override
  _EnterNameScreenState createState() => _EnterNameScreenState();
}

class _EnterNameScreenState extends State<EnterNameScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _saveNameAndScoreAndRestartGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'username', _nameController.text); // Save the username locally

    // Also, send the username to Firestore for cloud storage
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('players').add({
      'name': _nameController.text,
      // You can include other data to be stored in Firestore here, such as the score
      'score': widget.score,
      'timestamp': FieldValue
          .serverTimestamp(), // Add a server-side timestamp for sorting/ordering
    });

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
