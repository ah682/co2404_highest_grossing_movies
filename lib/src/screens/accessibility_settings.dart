import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '/src/models/font_model.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData theme) async {
    _themeData = theme;
    notifyListeners(); // This is crucial

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
  bool readableFont = false;

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
    });
  }

  Future<void> _updateSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);

    if (key == 'darkMode') {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      themeProvider.setTheme(value ? ThemeData.dark() : ThemeData.light());
      // No need for setState here since ThemeProvider's notifyListeners() will handle the update
    } else if (key == 'readableFont') {
      // Handle readable font setting
    }
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
