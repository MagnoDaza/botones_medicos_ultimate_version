import 'package:flutter/foundation.dart';

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
    if (_isBold != value) {
      _isBold = value;
      notifyListeners();
    }
  }

  set isItalic(bool value) {
    if (_isItalic != value) {
      _isItalic = value;
      notifyListeners();
    }
  }

  set isUnderline(bool value) {
    if (_isUnderline != value) {
      _isUnderline = value;
      notifyListeners();
    }
  }

  set isBorder(bool value) {
    if (_isBorder != value) {
      _isBorder = value;
      notifyListeners();
    }
  }

  void updateTextStyle({
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    bool? isBorder,
  }) {
    bool shouldNotify = false;

    if (isBold != null && _isBold != isBold) {
      _isBold = isBold;
      shouldNotify = true;
    }

    if (isItalic != null && _isItalic != isItalic) {
      _isItalic = isItalic;
      shouldNotify = true;
    }

    if (isUnderline != null && _isUnderline != isUnderline) {
      _isUnderline = isUnderline;
      shouldNotify = true;
    }

    if (isBorder != null && _isBorder != isBorder) {
      _isBorder = isBorder;
      shouldNotify = true;
    }

    if (shouldNotify) {
      notifyListeners();
    }
  }
}
