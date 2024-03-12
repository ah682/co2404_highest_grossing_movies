// font_model.dart
import 'package:flutter/material.dart';

class FontModel extends ChangeNotifier {
  String _fontFamily = 'Default'; // Default font family

  String get fontFamily => _fontFamily;

  void toggleFont(String fontFamily) {
    _fontFamily = fontFamily;
    notifyListeners();
  }
}
