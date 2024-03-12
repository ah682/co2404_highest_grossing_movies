import 'package:flutter/material.dart';

class TermsOfService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms & Service'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Terms & Service',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '1. Acceptance of Terms\n'
              'By accessing or using the TMDB Trivia Flutter App ("App"), you agree to be bound by these Terms of Service ("Terms"). If you disagree with any part of the terms, you may not access the App.\n'
              '2. Description of Service\n'
              'The App provides users with trivia games based on data sourced from The Movie Database (TMDB). Users can participate in quizzes, challenges, and other interactive features related to movies and TV shows.\n'
              '3. User Conduct\n'
              'Users are expected to use the App responsibly and respectfully. Any form of harassment, abuse, or violation of other users rights is strictly prohibited.'
              '4. Intellectual Property\n'
              'All content provided within the App, including but not limited to text, graphics, logos, and software, is the property of the App developers or its content suppliers and protected by intellectual property laws. Content sourced from TMDB is subject to TMDBs own terms and conditions.\n'
              '5. User Content\n'
              'Users may be able to submit content or participate in interactive features. By submitting content, you grant the App a non-exclusive, royalty-free license to use, modify, and display such content within the App.\n'
              '6. Disclaimers\n'
              'The App is provided on an AS IS and AS AVAILABLE basis. The developers do not guarantee the accuracy, completeness, or timeliness of information available from the App.\n'
              '7. Limitation of Liability\n'
              'The App developers shall not be liable for any direct, indirect, incidental, special, or consequential damages resulting from the use or inability to use the App.\n'
              '8. Modifications to Terms\n'
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
