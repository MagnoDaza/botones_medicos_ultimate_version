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

  // Añadir un botón a la lista
  void addButton(ButtonData buttonData) {
    _factoryButtons.add(buttonData);
    notifyListeners();
  }

  // Guardar un botón
  void saveButton(ButtonData buttonData) {
    _savedButtons.add(buttonData);
    notifyListeners();
  }

  // Seleccionar un botón
  void selectButton(int index) {
    if (index >= 0 && index < _factoryButtons.length) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  // Actualizar un botón en una posición específica
  void updateButton(int index, ButtonData newButtonData) {
    if (index >= 0 && index < _factoryButtons.length) {
      _factoryButtons[index] = newButtonData;
      notifyListeners();
    }
  }

  // Eliminar un botón en una posición específica
  void removeButton(int index) {
    if (index >= 0 && index < _savedButtons.length) {
      _savedButtons.removeAt(index);
      notifyListeners();
    }
  }

  // Inicializar botones con la fábrica de botones
  void initializeButtons(ButtonFactory buttonFactory,
      TextEditingController textController, QuillController controller) {
    if (!_buttonsInitialized) {
      for (ButtonType type in ButtonType.values) {
        addButton(buttonFactory.createButton(
          type,
          textController.text,
          Document(),
        ));
      }
      _buttonsInitialized = true;
      selectButton(0);
    }
  }

  // Crear un nuevo botón y reiniciar el botón seleccionado
  void createNewButton() {
    final newButton = buttonFactory.createButton(
      ButtonType.elevated, // Tipo predeterminado, puede modificarse
      _defaultText,
      Document(), // Nuevo documento vacío
    );

    // Agregar el nuevo botón a la lista de botones de fábrica
    addButton(newButton);

    // Seleccionar el nuevo botón
    _selectedIndex = _factoryButtons.length - 1;
    notifyListeners();
  }

  // Reiniciar el botón seleccionado con parámetros predeterminados
  void resetButton() {
    final resetButton = buttonFactory.createButton(
      ButtonType.elevated, // Tipo predeterminado, puede modificarse
      _defaultText,
      Document(), // Nuevo documento vacío
    );

    _factoryButtons[_selectedIndex] = resetButton;
    notifyListeners();
  }

  // Clonar el texto del botón con nuevos estilos
  // void cloneText(
  //   int index,
  //   String buttonText, {
  //   bool? isBold,
  //   bool? isItalic,
  //   bool? isUnderline,
  //   bool? isBorder,
  //   Document? document,
  // }) {
  //   _factoryButtons[_selectedIndex] = _factoryButtons[_selectedIndex].copyWith(
  //     text: _defaultText,
  //     isBold: isBold,
  //     isItalic: isItalic,
  //     isUnderline: isUnderline,
  //     isBorder: isBorder,
  //     document: document ?? Document(),
  //   );
  //   _selectedIndex = index;
  //   notifyListeners();
  // }

  void cloneText(
    int index,
    String buttonText, {
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    bool? isBorder,
    Document? document,
  }) {
    _factoryButtons[_selectedIndex] = _factoryButtons[_selectedIndex]
        .cloneWithText(
            newText: _defaultText,
            newIsBold: false,
            newIsItalic: false,
            newIsUnderline: false,
            newIsBorder: false,
            document: Document());
    _selectedIndex = index;
    _factoryButtons[_selectedIndex] = _factoryButtons[_selectedIndex]
        .cloneWithText(
            newText: buttonText,
            newIsBold: isBold ?? false,
            newIsItalic: isItalic ?? false,
            newIsUnderline: isUnderline ?? false,
            newIsBorder: isBorder ?? false,
            document: document ?? Document());
    notifyListeners();
  }

  // Actualizar estilo de texto del botón seleccionado
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
