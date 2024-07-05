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
    _selectedIndex = _factoryButtons.length - 1;
    notifyListeners();
  }

  void saveButton(ButtonData buttonData) {
    final index = _savedButtons.indexWhere((button) => button.id == buttonData.id);
    if (index != -1) {
      _savedButtons[index] = buttonData;
    } else {
      _savedButtons.add(buttonData);
    }
    // Eliminar de _factoryButtons después de guardar
    _factoryButtons.removeWhere((button) => button.id == buttonData.id);
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

  void discardButton(int index) {
    if (index >= 0 && index < _factoryButtons.length) {
      _factoryButtons.removeAt(index);
      notifyListeners();
    }
  }

  void initializeButtons() {
    if (!_buttonsInitialized) {
      final List<ButtonData> buttons = [];
      for (ButtonType type in ButtonType.values) {
        buttons.add(ButtonBuilder()
            .setType(type)
            .setText(_defaultText)
            .setDocument(Document())
            .build());
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
    _factoryButtons[_selectedIndex] = _factoryButtons[_selectedIndex].cloneWithText(
      newText: _defaultText,
      newIsBold: false,
      newIsItalic: false,
      newIsUnderline: false,
      newIsBorder: false,
      document: Document(),
    );
    _selectedIndex = index;
    _factoryButtons[_selectedIndex] = _factoryButtons[_selectedIndex].cloneWithText(
      newText: buttonText,
      newIsBold: isBold ?? false,
      newIsItalic: isItalic ?? false,
      newIsUnderline: isUnderline ?? false,
      newIsBorder: isBorder ?? false,
      document: document ?? Document(),
    );
    notifyListeners();
  }

  void updateButtonTextStyle(bool isBold, bool isItalic, bool isUnderline, bool isBorder) {
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
