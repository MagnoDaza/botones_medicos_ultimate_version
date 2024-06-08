import 'package:flutter/material.dart';

class ButtonNameNotifier with ChangeNotifier {
  String _currentButtonName = 'Elevated';

  String get currentButtonName => _currentButtonName;

  set currentButtonName(String name) {
    _currentButtonName = name;
    notifyListeners();
  }
}
