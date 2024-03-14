import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/models/font_model.dart'; // Adjust the import path as necessary
import 'src/screens/intro_screen.dart'; // Adjust the import path as necessary

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('darkMode') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FontModel()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(
            isDarkMode ? ThemeData.dark() : ThemeData.light(),
          ),
        ),
      ],
      child:
          MyApp(), // Ensure you have a MyApp widget or replace with your app's main widget
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      // Use Consumer to listen to ThemeProvider
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Your App Title',
          theme: themeProvider.getTheme(), // Use the theme from ThemeProvider
          home: IntroScreen(),
        );
      },
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData getTheme() => _themeData;

  void setTheme(ThemeData theme) async {
    _themeData = theme;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', _themeData.brightness == Brightness.dark);
  }
}
