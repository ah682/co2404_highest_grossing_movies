import 'package:flutter/material.dart';
import 'accessibility_settings.dart'; // Import the screen for accessibility settings
import 'privacy_policy.dart'; // Import the screen that displays the privacy policy
import 'terms_of_service.dart'; // Import the screen for the terms of service

// SettingsPage is a simple StatelessWidget that displays a list of setting options.
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Scaffold provides the high-level structure for the screen layout.
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Settings Page'), // The title of the AppBar displayed at the top of the settings page.
      ),
      // The body of the Scaffold is a Column widget that organizes its children vertically.
      body: Column(
        children: [
          // Expanded widget makes the ListView take up all the available space, except for the app version container.
          Expanded(
            child: ListView(
              // ListView allows the user to scroll through the list items if they do not fit on the screen.
              children: [
                // ListTile for Accessibility settings option.
                ListTile(
                  title: Text('Accessibility'),
                  onTap: () {
                    // onTap navigates to the AccessibilitySettings screen when the ListTile is tapped.
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => AccessibilitySettings()),
                    );
                  },
                ),
                // ListTile for Privacy Policy option.
                ListTile(
                  title: Text('Privacy Policy'),
                  onTap: () {
                    // onTap navigates to the PrivacyPolicy screen when tapped.
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                    );
                  },
                ),
                // ListTile for Terms & Conditions option.
                ListTile(
                  title: Text('Terms & Conditions'),
                  onTap: () {
                    // onTap navigates to the TermsOfService screen when tapped.
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TermsOfService()),
                    );
                  },
                ),
              ],
            ),
          ),
          // Container that displays the app version at the bottom of the screen.
          Container(
            alignment:
                Alignment.center, // Centers the text inside the container.
            padding: EdgeInsets.all(16), // Padding inside the container.
            child: Text(
              'App Version\nv1.0', // The text to display the app version.
              textAlign: TextAlign
                  .center, // Aligns the text to the center of the container.
              style: TextStyle(
                fontSize: 16, // Sets the font size of the text.
                color: Colors.grey, // Sets the color of the text to grey.
              ),
            ),
          ),
        ],
      ),
    );
  }
}
