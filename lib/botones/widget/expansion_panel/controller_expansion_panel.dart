import 'package:flutter/material.dart';

class ExpansionPanelController extends ChangeNotifier {
  int _expandedIndex = -1; // Initially no panel is expanded

  int get expandedIndex => _expandedIndex;

  void setExpandedIndex(int index) {
    if (_expandedIndex == index) {
      _expandedIndex = -1; // Collapse if the same panel is tapped
    } else {
      _expandedIndex = index;
    }
    notifyListeners();
  }
}
