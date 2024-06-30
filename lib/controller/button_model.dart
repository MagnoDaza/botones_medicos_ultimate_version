import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../botones/button_data.dart';
import '../botones/boton/button_factory.dart';

class ButtonModel with ChangeNotifier {
  final List<ButtonData> _factoryButtons = [];
  final List<ButtonData> _savedButtons = [];
  final String _defaultText = 'Servicio';
  int _selectedIndex = 0;
  bool _buttonsInitialized = false;
  final ButtonFactory buttonFactory;

  ButtonModel(this.buttonFactory);

  List<ButtonData> get factoryButtons => _factoryButtons;
  int get selectedIndex => _selectedIndex;
  List<ButtonData> get savedButtons => _savedButtons;
  bool get buttonsInitialized => _buttonsInitialized;

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
    if (index >= 0 && index < _savedButtons.length) {
      _savedButtons.removeAt(index);
      notifyListeners();
    }
  }

  void initializeButtons(ButtonFactory buttonFactory, TextEditingController textController, QuillController controller) {
    if (!_buttonsInitialized) {
      for (ButtonType type in ButtonType.values) {
        addButton(buttonFactory.createButton(type, textController.text, controller.document));
      }
      _buttonsInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        selectButton(0);
      });
    }
  }

  void createNewButton() {
    final newButton = buttonFactory.createButton(
      ButtonType.elevated, // Tipo predeterminado, puede modificarse
      _defaultText,
      Document(), // Nuevo documento vacío
    );
    addButton(newButton);
    _selectedIndex = _factoryButtons.length - 1;
    notifyListeners();
  }

  void resetButton() {
    final resetButton = buttonFactory.createButton(
      ButtonType.elevated, // Tipo predeterminado, puede modificarse
      _defaultText,
      Document(), // Nuevo documento vacío
    );
    _factoryButtons[_selectedIndex] = resetButton;
    notifyListeners();
  }

  void cloneText(int index, String buttonText, {bool? isBold, bool? isItalic, bool? isUnderline, bool? isBorder, Document? document}) {
    _factoryButtons[_selectedIndex] = _factoryButtons[_selectedIndex]
        .cloneWithText(
      newText: _defaultText,
      newIsBold: false,
      newIsItalic: false,
      newIsUnderline: false,
      newIsBorder: false,
      document: Document(),
    );
    _selectedIndex = index;
    _factoryButtons[_selectedIndex] = _factoryButtons[_selectedIndex]
        .cloneWithText(
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

  void createNewButtonFromSelected() {
    final selectedButton = factoryButtons[selectedIndex];
    final newButton = buttonFactory.createButton(
      selectedButton.type, // Basado en el tipo del botón seleccionado
      selectedButton.text, // Texto del botón seleccionado
      selectedButton.document, // Documento del botón seleccionado
    );
    addButton(newButton);
    selectButton(factoryButtons.length - 1); // Selecciona el nuevo botón
  }
}
