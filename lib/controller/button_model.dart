import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../botones/boton/button_factory.dart';
import '../botones/button_data.dart';

// Modelo para gestión de botones
class ButtonModel with ChangeNotifier {
  final List<ButtonData> _factoryButtons = [];
  final List<ButtonData> _savedButtons = [];
  final String _defaultText = 'Servicio';
  int _selectedIndex = 0;
  bool _buttonsInitialized = false;

  final Document _emptyDocument = Document();

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
            type, textController.text, controller.document));
      }
      _buttonsInitialized = true;
      selectButton(0);
    }
  }

  // Crear un nuevo botón y reiniciar el botón seleccionado
  void resetButton() {
    final buttonModel = this;
    final selectedButton =
        buttonModel.factoryButtons[buttonModel.selectedIndex];
    final resetButton = buttonFactory.createButton(
        selectedButton.type, // Tipo predeterminado, puede modificarse
        _defaultText,
        _emptyDocument // Nuevo documento vacío
        );

    updateButton(_selectedIndex, resetButton);
    //refresca el boton seleccionado
    selectButton(_selectedIndex);
    notifyListeners();
  }

  // Clonar el texto del botón con nuevos estilos
  void cloneText(
    int index,
    String buttonText, {
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    bool? isBorder,
    Document? document,
  }) {
    _factoryButtons[_selectedIndex] =
        _factoryButtons[_selectedIndex].cloneWithText(
      newText: _defaultText,
      newIsBold: false,
      newIsItalic: false,
      newIsUnderline: false,
      newIsBorder: false,
      //clona los datos del documento actual
      document: document ?? _factoryButtons[_selectedIndex].document,
    );
    _selectedIndex = index;
    _factoryButtons[_selectedIndex] =
        _factoryButtons[_selectedIndex].cloneWithText(
      newText: buttonText,
      newIsBold: false,
      newIsItalic: false,
      newIsUnderline: false,
      newIsBorder: false,
      //clona los datos del documento actual
      document: document ?? _factoryButtons[_selectedIndex].document,
    );
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
