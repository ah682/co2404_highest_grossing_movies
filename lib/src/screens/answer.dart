import 'package:flutter/material.dart';

// AnswerScreen widget is used to display the result of a trivia round.
class AnswerScreen extends StatelessWidget {
  // Variables to hold the state of the current question round.
  final bool isCorrect; // Indicates whether the answer was correct.
  final int currentScore; // The current score of the user.
  final int currentRound; // The current round number.
  final VoidCallback
      onNextRound; // Callback function to proceed to the next round.

  // Constructor to initialize the AnswerScreen with required properties.
  AnswerScreen({
    required this.isCorrect,
    required this.currentScore,
    required this.currentRound,
    required this.onNextRound,
  });

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the structure for the screen layout.
    return Scaffold(
      appBar: AppBar(
        title: Text('Round Over'), // Title for the AppBar.
        automaticallyImplyLeading: false, // Disables the back button in AppBar.
      ),
      body: Center(
        // Center widget to center the child Column widget.
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Column takes up minimum space needed.
          children: [
            Text(
              'Round $currentRound Over', // Displays which round is over.
              style: TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold, // Bold font for the round over text.
              ),
            ),
            SizedBox(height: 8), // Adds vertical spacing between widgets.
            Text(
              isCorrect
                  ? 'Correct'
                  : 'Incorrect', // Display 'Correct' or 'Incorrect' based on isCorrect boolean.
              style: TextStyle(
                fontSize: 20,
                color: isCorrect
                    ? Colors.green
                    : Colors.red, // Green text for correct, red for incorrect.
              ),
            ),
            Divider(), // Visual divider line.
            Text(
              'You have $currentScore Points', // Shows the current score.
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20), // Adds vertical spacing between widgets.
            ElevatedButton(
              onPressed:
                  onNextRound, // Calls onNextRound callback when pressed.
              child: Text(
                'Start Next Round', // Text displayed on the button.
                style: TextStyle(
                  color:
                      Colors.white, // Text color is white for better contrast.
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context)
                    .primaryColor, // Button color uses the primary color from the theme.
                padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15), // Button padding for better touch area.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
