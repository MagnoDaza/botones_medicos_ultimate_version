import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../botones/button_data.dart';

class ButtonModel with ChangeNotifier {
  final List<ButtonData> _factoryButtons = [];
  final List<ButtonData> _savedButtons = [];
  final String _defaultText = 'Servicio';

  int _selectedIndex = 0;
  bool _buttonsInitialized = false; // Flag to check if buttons are initialized

  ButtonModel(ButtonFactory buttonFactory);

  List<ButtonData> get factoryButtons => _factoryButtons;
  int get selectedIndex => _selectedIndex;
  List<ButtonData> get savedButtons => _savedButtons;
  bool get buttonsInitialized => _buttonsInitialized; // Getter for the flag

  void addButton(ButtonData buttonData) {
    _factoryButtons.add(buttonData);
    notifyListeners();
  }

  void saveButton(ButtonData buttonData) {
    _savedButtons.add(buttonData);
    notifyListeners();
  }

  void selectButton(int index) {
    if (index >= 0 && index < _factoryButtons.length) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  void updateButton(int index, ButtonData newButtonData) {
    if (index >= 0 && index < _factoryButtons.length) {
      _factoryButtons[index] = newButtonData;
      notifyListeners();
    }
  }

  void removeButton(int index) {
    if (index >= 0 && index < _factoryButtons.length) {
      _factoryButtons.removeAt(index);
      notifyListeners();
    }
  }

  void clearButtons() {
    _factoryButtons.clear();
    notifyListeners();
  }

  void initializeButtons(
      ButtonFactory buttonFactory, TextEditingController controller) {
    if (!_buttonsInitialized) {
      for (ButtonType type in ButtonType.values) {
        addButton(buttonFactory.createButton(
            type, controller.text, QuillController.basic()));
      }
      _buttonsInitialized = true;
      selectButton(0);
    }
  }

// Clone the text of the button at the given index is bold, italic, underline, and border
  void cloneText(int index, String buttonText,
      {bool? isBold, bool? isItalic, bool? isUnderline, bool? isBorder}) {
    _factoryButtons[_selectedIndex] = _factoryButtons[_selectedIndex]
        .cloneWithText(_defaultText, isBold = false, isItalic = false,
            isUnderline = false, isBorder = false);
    _selectedIndex = index;
    _factoryButtons[_selectedIndex] = _factoryButtons[_selectedIndex]
        .cloneWithText(buttonText, isBold, isItalic, isUnderline, isBorder);

    notifyListeners();
  }

  void updateButtonTextStyle(
    bool isBold,
    bool isItalic,
    bool isUnderline,
    bool isBorder,
  ) {
    var button = factoryButtons[selectedIndex];
    factoryButtons[selectedIndex] = button.copyWith(
      isBold: isBold,
      isItalic: isItalic,
      isUnderline: isUnderline,
      isBorder: isBorder,
    );
    notifyListeners();
  }
}
