import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '/src/models/font_model.dart'; // Ensure this is correctly pointing to your FontModel file

class AccessibilitySettings extends StatefulWidget {
  @override
  _AccessibilitySettingsState createState() => _AccessibilitySettingsState();
}

class _AccessibilitySettingsState extends State<AccessibilitySettings> {
  bool darkMode = false;
  bool readableFont = false;
  bool alphabetOrdering = false;
  bool chronologicalOrdering = true; // Assuming this is the default setting

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      darkMode = prefs.getBool('darkMode') ?? false;
      readableFont = prefs.getBool('readableFont') ?? false;
      alphabetOrdering = prefs.getBool('alphabetOrdering') ?? false;
      chronologicalOrdering = prefs.getBool('chronologicalOrdering') ?? true;
    });
  }

  Future<void> _updateSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool(key, value);
      if (key == 'alphabetOrdering' && value == true) {
        chronologicalOrdering = !value;
        prefs.setBool('chronologicalOrdering', !value);
      } else if (key == 'chronologicalOrdering' && value == true) {
        alphabetOrdering = !value;
        prefs.setBool('alphabetOrdering', !value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accessibility Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            value: darkMode,
            onChanged: (bool newValue) {
              _updateSetting('darkMode', newValue);
            },
          ),
          SwitchListTile(
            title: Text('Readable Font and Dyslexia Mode'),
            value: readableFont,
            onChanged: (bool newValue) {
              setState(() {
                readableFont = newValue;
              });
              final fontModel = Provider.of<FontModel>(context, listen: false);
              fontModel.toggleFont(newValue ? 'OpenDyslexic' : 'Roboto');
            },
          ),
          SwitchListTile(
            title: Text('Alphabet Ordering'),
            value: alphabetOrdering,
            onChanged: (bool newValue) {
              if (!chronologicalOrdering || newValue) {
                _updateSetting('alphabetOrdering', newValue);
              }
            },
          ),
          SwitchListTile(
            title: Text('Chronological Ordering'),
            value: chronologicalOrdering,
            onChanged: (bool newValue) {
              if (!alphabetOrdering || newValue) {
                _updateSetting('chronologicalOrdering', newValue);
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Choose what accessibility settings you wish to use below',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
