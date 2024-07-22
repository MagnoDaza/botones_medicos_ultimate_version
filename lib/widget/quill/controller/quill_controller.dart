import 'package:flutter/material.dart';

class QuillProvider with ChangeNotifier {
  bool _useCustomQuillToolbar = false;

  bool get useCustomQuillToolbar => _useCustomQuillToolbar;

  void toggleCustomQuillToolbar() {
    _useCustomQuillToolbar = !_useCustomQuillToolbar;
    notifyListeners();
  }
}
