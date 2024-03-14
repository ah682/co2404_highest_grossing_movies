import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/models/font_model.dart'; // Adjust the import path as necessary
import 'src/screens/intro_screen.dart'; // Adjust the import path as necessary
import 'src/screens/accessibility_settings.dart'; // Adjust the import path as necessary

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('darkMode') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FontModel()),
        ChangeNotifierProvider(
          create: (_) =>
              ThemeProvider(isDarkMode ? ThemeData.dark() : ThemeData.light()),
        ),
      ],
      child: MyApp(), // MyApp is Root widget
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Consumer<ThemeProvider> listens for theme changes
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // MaterialApp rebuilds whenever themeProvider notifies listeners
        return MaterialApp(
          title: 'Your App Title',
          theme: themeProvider.getTheme(), // Applies the current theme
          home: IntroScreen(), // Your app's home screen
        );
      },
    );
  }
}
