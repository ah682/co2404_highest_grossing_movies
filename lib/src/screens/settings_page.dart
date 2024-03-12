import 'package:flutter/material.dart';
import 'accessibility_settings.dart';
import 'privacy_policy.dart';
import 'terms_of_service.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Accessibility'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => AccessibilitySettings()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Privacy Policy'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Terms & Conditions'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TermsOfService()),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16),
            child: Text(
              'App Version\nv1.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
