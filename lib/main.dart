// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/models/font_model.dart';
import 'src/screens/intro_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FontModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Trivia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: IntroScreen(), // Set IntroScreen as the initial screen of the app.
    );
  }
}
