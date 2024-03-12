import 'package:flutter/material.dart';

class AnswerScreen extends StatelessWidget {
  final bool isCorrect;
  final int currentScore;
  final int currentRound;
  final VoidCallback onNextRound;

  AnswerScreen({
    required this.isCorrect,
    required this.currentScore,
    required this.currentRound,
    required this.onNextRound,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Round Over'),
        automaticallyImplyLeading: false, // Disables the back button
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Round $currentRound Over',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              isCorrect ? 'Correct' : 'Incorrect',
              style: TextStyle(
                fontSize: 20,
                color: isCorrect ? Colors.green : Colors.red,
              ),
            ),
            Divider(),
            Text(
              'You have $currentScore Points',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onNextRound,
              child: Text(
                'Start Next Round',
                style: TextStyle(
                  color: Colors
                      .white, // Ensure the text color contrasts well with the button color
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor, // Button color
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
