import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '1. How We Use Your Information\n'
              'In Short: We use the information we collect about you or that you provide to us, including any game-related data, to provide you with the App and its contents, and to improve our App.\n'
              'The game data we collect helps us to:\n'
              'Provide you with a personalized gaming experience.\n'
              'Enable your participation in leaderboards and competitions.\n'
              'Improve the App by analyzing how users interact with the game.\n'
              '2. Disclosure of Your Information\n'
              'In Short: We do not share, sell, rent, or trade your game-related data with any third parties for their commercial purposes.\n'
              '3. Modifications to Terms\n'
              'The App developers reserve the right to modify these Terms at any time. Your continued use of the App following any such modifications signifies your acceptance of the new Terms.\n',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            // Add more Text widgets for additional paragraphs as needed.
          ],
        ),
      ),
    );
  }
}
