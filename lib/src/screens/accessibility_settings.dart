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
  getTheme() => _themeData;

  // Setter to update the theme and notify listeners about the change.
  setTheme(ThemeData theme) async {
    _themeData = theme;
    notifyListeners(); // Notify widgets that are listening to this provider to rebuild.

    // Save the theme preference to local storage using SharedPreferences.
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', _themeData.brightness == Brightness.dark);
  }
}

// AccessibilitySettings is a StatefulWidget that manages accessibility settings in the app.
class AccessibilitySettings extends StatefulWidget {
  @override
  _AccessibilitySettingsState createState() => _AccessibilitySettingsState();
}

// State class for AccessibilitySettings, where the actual logic resides.
class _AccessibilitySettingsState extends State<AccessibilitySettings> {
  bool darkMode = false;
  bool readableFont = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

// Update the setting based on the key and value provided, and save it to SharedPreferences.
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      darkMode = prefs.getBool('darkMode') ?? false;
      readableFont = prefs.getBool('readableFont') ?? false;
    });
  }

// Update the theme or font setting based on the key and notify the respective provider.
  Future<void> _updateSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);

// Update the theme or font setting based on the key and notify the respective provider.
    if (key == 'darkMode') {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      themeProvider.setTheme(value ? ThemeData.dark() : ThemeData.light());
      // ThemeProvider's notifyListeners is called within setTheme, so no need to call setState here.
    } else if (key == 'readableFont') {
      // Handle readable font setting
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the basic material design visual layout structure.
    return Scaffold(
      appBar: AppBar(
        title: Text('Accessibility Settings'),
      ),
      body: ListView(
        // ListView to allow scrolling of settings.
        children: [
          SwitchListTile(
            // Toggle switch for enabling/disabling dark mode.
            title: Text('Dark Mode'),
            value: darkMode,
            onChanged: (bool newValue) {
              _updateSetting(
                  'darkMode', newValue); // Update the dark mode setting.
            },
          ),
          SwitchListTile(
            title: Text('Readable Font and Dyslexia Mode'),
            value: readableFont,
            onChanged: (bool newValue) {
              setState(() {
                readableFont = newValue;
              });
              // Update the readable font mode setting in the FontModel provider.
              final fontModel = Provider.of<FontModel>(context, listen: false);
              fontModel.toggleFont(newValue ? 'OpenDyslexic' : 'Roboto');
            },
          ),
          Padding(
            // Padding for the text below the switches.
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
