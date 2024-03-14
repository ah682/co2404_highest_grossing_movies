import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '/src/models/font_model.dart';

// ThemeProvider is a ChangeNotifier that allows listeners to rebuild when changes occur.
class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  // Constructor takes an initial ThemeData.
  ThemeProvider(this._themeData);

  // Getter to retrieve the current theme data.
  ThemeData getTheme() => _themeData;

  // Setter to update the theme and notify listeners about the change.
  void setTheme(ThemeData theme) async {
    _themeData = theme;
    notifyListeners(); // Notify widgets that are listening to this provider to rebuild.

    // Save the theme preference to local storage using SharedPreferences.
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', _themeData.brightness == Brightness.dark);
  }
}

class AccessibilitySettings extends StatefulWidget {
  @override
  _AccessibilitySettingsState createState() => _AccessibilitySettingsState();
}

class _AccessibilitySettingsState extends State<AccessibilitySettings> {
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> _updateDarkModeSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        'darkMode', value); // Save the dark mode setting to SharedPreferences

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.setTheme(value
        ? ThemeData.dark()
        : ThemeData.light()); // Update the theme in ThemeProvider
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
              setState(() {
                darkMode =
                    newValue; // Update the dark mode state immediately for a responsive UI
              });
              _updateDarkModeSetting(newValue); // Update the dark mode setting
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Choose what accessibility settings you wish to use below',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
