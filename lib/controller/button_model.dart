import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../botones/button_data.dart';
import '../botones/patron_builder/button_builder.dart';

class ButtonModel with ChangeNotifier {
  final List<ButtonData> _factoryButtons = [];
  final List<ButtonData> _savedButtons = [];
  final String _defaultText = 'Servicio';
  int _selectedIndex = 0;
  bool _buttonsInitialized = false;

  List<ButtonData> get factoryButtons => _factoryButtons;
  int get selectedIndex => _selectedIndex;
  List<ButtonData> get savedButtons => _savedButtons;
  bool get buttonsInitialized => _buttonsInitialized;

  void addButton(ButtonData buttonData) {
    _factoryButtons.add(buttonData);
    notifyListeners();
  }

  void saveButton(ButtonData buttonData) {
    final index = _savedButtons.indexWhere((button) => button.id == buttonData.id);
    if (index != -1) {
      _savedButtons[index] = buttonData;
    } else {
      _savedButtons.add(buttonData);
    }
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
    if (index >= 0 && index < _savedButtons.length) {
      _savedButtons.removeAt(index);
      notifyListeners();
    }
  }

  void initializeButtons() {
    if (!_buttonsInitialized) {
      final List<ButtonData> buttons = [];
      for (ButtonType type in ButtonType.values) {
        final button = ButtonBuilder()
            .setType(type)
            .setText(_defaultText)
            .setDocument(Document())
            .build();
        buttons.add(button);
      }
      _factoryButtons.addAll(buttons);
      _buttonsInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        selectButton(0);
      });
    }
  }

  void createNewButton(ButtonType type) {
    final newButton = ButtonBuilder()
        .setType(type)
        .setText(_defaultText)
        .setDocument(Document())
        .build();
    addButton(newButton);
    _selectedIndex = _factoryButtons.length - 1;
    notifyListeners();
  }

  void resetButton() {
    final selectedButton = _factoryButtons[_selectedIndex];
    final resetButton = ButtonBuilder()
        .setType(selectedButton.type)
        .setText(_defaultText)
        .setDocument(Document())
        .build();
    updateButton(_selectedIndex, resetButton);
    notifyListeners();
  }

  void cloneText(int index, String buttonText,
      {bool? isBold, bool? isItalic, bool? isUnderline, bool? isBorder, Document? document}) {
    final selectedButton = _factoryButtons[_selectedIndex];
    final clonedButton = ButtonBuilder()
        .fromButtonData(selectedButton)
        .setText(_defaultText)
        .setBold(false)
        .setItalic(false)
        .setUnderline(false)
        .setBorder(false)
        .setDocument(Document())
        .build();
    _factoryButtons[_selectedIndex] = clonedButton;
    _selectedIndex = index;
    final newButton = ButtonBuilder()
        .fromButtonData(clonedButton)
        .setText(buttonText)
        .setBold(isBold ?? false)
        .setItalic(isItalic ?? false)
        .setUnderline(isUnderline ?? false)
        .setBorder(isBorder ?? false)
        .setDocument(document ?? Document())
        .build();
    _factoryButtons[_selectedIndex] = newButton;
    notifyListeners();
  }

  void updateButtonTextStyle(bool isBold, bool isItalic, bool isUnderline, bool isBorder) {
    var button = _factoryButtons[_selectedIndex];
    button = ButtonBuilder()
        .fromButtonData(button)
        .setBold(isBold)
        .setItalic(isItalic)
        .setUnderline(isUnderline)
        .setBorder(isBorder)
        .build();
    _factoryButtons[_selectedIndex] = button;
    notifyListeners();
  }
}
