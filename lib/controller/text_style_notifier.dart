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

  void setBold(bool value) => _updateStyle(() => _isBold = value);
  void setItalic(bool value) => _updateStyle(() => _isItalic = value);
  void setUnderline(bool value) => _updateStyle(() => _isUnderline = value);
  void setBorder(bool value) => _updateStyle(() => _isBorder = value);

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

  void resetTextStyle() {
    _isBold = false;
    _isItalic = false;
    _isUnderline = false;
    _isBorder = false;
    notifyListeners();
  }

  void _updateStyle(VoidCallback updateFn) {
    updateFn();
    notifyListeners();
  }
}
