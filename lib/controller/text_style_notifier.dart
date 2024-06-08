import 'package:flutter/material.dart';

class TextStyleNotifier with ChangeNotifier {
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  bool _isBorder = false;

  bool get isBold => _isBold;
  bool get isItalic => _isItalic;
  bool get isUnderline => _isUnderline;
  bool get isBorder => _isBorder;

  set isBold(bool value) {
    _isBold = value;
    notifyListeners();
  }

  set isItalic(bool value) {
    _isItalic = value;
    notifyListeners();
  }

  set isUnderline(bool value) {
    _isUnderline = value;
    notifyListeners();
  }

  set isBorder(bool value) {
    _isBorder = value;
    notifyListeners();
  }

  void reset() {
    isBold = false;
    isItalic = false;
    isUnderline = false;
    isBorder = false;
    notifyListeners();
  }
}
