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

  // Métodos nuevos para CRUD

  // Inicializar la creación de un nuevo botón
  void initializeCreation(String defaultText, Document document) {
    _factoryButtons.clear();

    for (int i = 0; i < 3; i++) {
      addButton(buttonFactory.createButton(
        ButtonType.values[i], // Tipo de botón
        _defaultText,
        document, // Documento Quill predeterminado
      ));
    }
  

    // ));
    _selectedIndex = 0;
    notifyListeners();
  }

  // Método para cargar más botones
  void loadMoreButtons() {
    int currentCount = _factoryButtons.length;
    // Asumiendo que hay más tipos de botones para cargar
    for (int i = currentCount;
        i < currentCount + 3 && i < ButtonType.values.length;
        i++) {
      addButton(buttonFactory.createButton(
        ButtonType.values[i], // Tipo de botón
        _defaultText,
        QuillController.basic().document, // Documento Quill predeterminado
      ));
    }
    notifyListeners();
  }

  // Actualizar los atributos de un botón
  void updateButtonAttributes(Map<String, dynamic> newValues) {
    if (_selectedIndex >= 0 && _selectedIndex < _factoryButtons.length) {
      ButtonData updatedButton = _factoryButtons[_selectedIndex].copyWith(
        text: newValues['text'],
        isBold: newValues['isBold'],
        isItalic: newValues['isItalic'],
        isUnderline: newValues['isUnderline'],
        isBorder: newValues['isBorder'],
      );
      _factoryButtons[_selectedIndex] = updatedButton;
      notifyListeners();
    }
  }

  // Guardar los cambios en un botón editado
  void saveEditedButton(String text, Document document) {
    if (_selectedIndex >= 0 && _selectedIndex < _savedButtons.length) {
      ButtonData updatedButton = _savedButtons[_selectedIndex].copyWith(
        text: text,
        document: document,
      );
      _savedButtons[_selectedIndex] = updatedButton;
      notifyListeners();
    }
  }

  // Crear un nuevo botón y añadirlo a la lista
  void createNewButton(String text, Document document) {
    final buttonModel = this;
    final selectedButton =
        buttonModel.factoryButtons[buttonModel.selectedIndex];

    ButtonData newButton = buttonFactory.createButton(
      selectedButton.type,
      text,
      document,
    );
    _savedButtons.add(newButton);
    notifyListeners();
  }

  // Método para inicializar la edición de un botón existente
  void initializeEdit(ButtonData buttonData) {
    _factoryButtons.clear();
    _factoryButtons.add(buttonData);
    _selectedIndex = _savedButtons.indexWhere((b) => b.id == buttonData.id);
    notifyListeners();
  }

  // Método para clonar los parámetros de un botón a otro
  void cloneButtonParameters(int sourceIndex, int targetIndex) {
    if (sourceIndex >= 0 &&
        sourceIndex < _factoryButtons.length &&
        targetIndex >= 0 &&
        targetIndex < _factoryButtons.length) {
      ButtonData sourceButton = _factoryButtons[sourceIndex];
      ButtonData targetButton = _factoryButtons[targetIndex].copyWith(
        text: sourceButton.text,
        isBold: sourceButton.isBold,
        isItalic: sourceButton.isItalic,
        isUnderline: sourceButton.isUnderline,
        isBorder: sourceButton.isBorder,
        document: sourceButton.document,
      );
      _factoryButtons[targetIndex] = targetButton;
      notifyListeners();
    }
  }

  // Método para cambiar el tipo de un botón durante la edición
  void changeButtonType(int index, ButtonType newType) {
    if (index >= 0 && index < _factoryButtons.length) {
      ButtonData currentButton = _factoryButtons[index];
      ButtonData updatedButton = buttonFactory.createButton(
        newType,
        currentButton.text,
        currentButton.document,
        // isBold: currentButton.isBold,
        // isItalic: currentButton.isItalic,
        // isUnderline: currentButton.isUnderline,
        // isBorder: currentButton.isBorder,
      );
      _factoryButtons[index] = updatedButton;
      notifyListeners();
    }
  }
}
