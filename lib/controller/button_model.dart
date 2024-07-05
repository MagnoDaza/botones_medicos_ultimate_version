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

  /// Añadir botón temporal a la lista de plantillas
  void addButton(ButtonData buttonData) {
    _factoryButtons.add(buttonData);
    notifyListeners();
  }

  /// Guardar el botón y moverlo a la lista de botones guardados
  void saveButton() {
    if (_selectedIndex < 0 || _selectedIndex >= _factoryButtons.length) {
      return; // No hay botón seleccionado para guardar
    }
    final buttonData = _factoryButtons[_selectedIndex];
    final index = _savedButtons.indexWhere((button) => button.id == buttonData.id);
    if (index != -1) {
      _savedButtons[index] = buttonData;
    } else {
      _savedButtons.add(buttonData);
    }
    // Remover el botón temporal después de guardarlo
    _factoryButtons.removeAt(_selectedIndex);
    _selectedIndex = _factoryButtons.isNotEmpty ? 0 : -1;
    notifyListeners();
  }

  /// Seleccionar botón de la lista temporal
  void selectButton(int index) {
    if (index >= 0 && index < _factoryButtons.length) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  /// Actualizar botón temporal
  void updateButton(int index, ButtonData newButtonData) {
    if (index >= 0 && index < _factoryButtons.length) {
      _factoryButtons[index] = newButtonData;
      notifyListeners();
    }
  }

  /// Remover botón de la lista guardada
  void removeButton(int index) {
    if (index >= 0 && index < _savedButtons.length) {
      _savedButtons.removeAt(index);
      notifyListeners();
    }
  }

  /// Inicializar botones de plantilla
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

  /// Crear nuevo botón temporal
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

  /// Restablecer botón temporal seleccionado
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

  /// Clonar texto en el botón temporal
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

  /// Actualizar estilo de texto del botón temporal
  void updateButtonTextStyle(bool isBold, bool isItalic, bool isUnderline, bool isBorder) {
    if (_selectedIndex < 0 || _selectedIndex >= _factoryButtons.length) {
      return; // No hay botón seleccionado para actualizar
    }
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
