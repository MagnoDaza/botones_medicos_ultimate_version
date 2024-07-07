import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../botones/button_data.dart';
import '../botones/patron_builder/button_builder.dart';

class ButtonModel with ChangeNotifier {
  final List<ButtonData> _factoryButtons = [];
  final List<ButtonData> _savedButtons = [];
  final String _defaultText = 'Servicio';
  int _selectedIndex = -1;
  bool _buttonsInitialized = false;
  ButtonData? _temporaryButton; // Nueva instancia temporal para edición

  List<ButtonData> get factoryButtons => List.unmodifiable(_factoryButtons);
  int get selectedIndex => _selectedIndex;
  List<ButtonData> get savedButtons => List.unmodifiable(_savedButtons);
  bool get buttonsInitialized => _buttonsInitialized;
  ButtonData? get temporaryButton => _temporaryButton; // Obtener la instancia temporal

  /// Añadir botón temporal a la lista de plantillas
  void addButton(ButtonData buttonData) {
    _factoryButtons.add(buttonData);
    notifyListeners();
  }

  /// Guardar el botón y moverlo a la lista de botones guardados
  void saveButton() {
    if (_temporaryButton == null) return;
    final index = _savedButtons.indexWhere((button) => button.id == _temporaryButton!.id);
    if (index != -1) {
      _savedButtons[index] = _temporaryButton!;
    } else {
      _savedButtons.add(_temporaryButton!);
    }
    _temporaryButton = null;
    notifyListeners();
  }

  /// Seleccionar botón de la lista temporal y crear instancia temporal
  void selectButton(int index) {
    if (index >= 0 && index < _factoryButtons.length) {
      _selectedIndex = index;
      _temporaryButton = ButtonBuilder().fromButtonData(_factoryButtons[index]).build();
      notifyListeners();
    }
  }

  /// Seleccionar botón de la lista de botones guardados y crear instancia temporal
  void selectSavedButton(int index) {
    if (index >= 0 && index < _savedButtons.length) {
      _selectedIndex = index;
      _temporaryButton = ButtonBuilder().fromButtonData(_savedButtons[index]).build();
      notifyListeners();
    }
  }

  /// Actualizar botón temporal
  void updateButton(ButtonData updatedButton) {
    if (_temporaryButton != null && _temporaryButton!.id == updatedButton.id) {
      _temporaryButton = updatedButton;
      notifyListeners();
    }
  }

  /// Establecer el botón temporal para edición
  void setTemporaryButton(ButtonData button) {
    _temporaryButton = ButtonBuilder().fromButtonData(button).build();
    notifyListeners();
  }

  /// Remover botón de la lista guardada
  void removeButton(int index) {
    if (index >= 0 && index < _savedButtons.length) {
      _savedButtons.removeAt(index);
      notifyListeners();
    }
  }

  /// Crear nuevo botón temporal
  void createNewButton(ButtonType type) {
    final newButton = ButtonBuilder()
        .setType(type)
        .setText(_defaultText)
        .setDocument(Document())
        .build();
    _temporaryButton = newButton;
    notifyListeners();
  }

  /// Restablecer botón temporal seleccionado
  void resetButton() {
    if (_temporaryButton != null) {
      _temporaryButton = ButtonBuilder()
          .setType(_temporaryButton!.type)
          .setText(_defaultText)
          .setDocument(Document())
          .build();
      notifyListeners();
    }
  }

  /// Clonar texto en el botón temporal
  void cloneText(String buttonText,
      {bool? isBold, bool? isItalic, bool? isUnderline, bool? isBorder, Document? document}) {
    if (_temporaryButton != null) {
      _temporaryButton = _temporaryButton!.copyWith(
        text: buttonText,
        isBold: isBold ?? false,
        isItalic: isItalic ?? false,
        isUnderline: isUnderline ?? false,
        isBorder: isBorder ?? false,
        document: document ?? Document(),
      );
      notifyListeners();
    }
  }

  /// Actualizar estilo de texto del botón temporal
  void updateButtonTextStyle(bool isBold, bool isItalic, bool isUnderline, bool isBorder) {
    if (_temporaryButton != null) {
      _temporaryButton = _temporaryButton!.copyWith(
        isBold: isBold,
        isItalic: isItalic,
        isUnderline: isUnderline,
        isBorder: isBorder,
      );
      notifyListeners();
    }
  }

  /// Restablecer el botón temporal
  void resetTemporaryButton() {
    _temporaryButton = null;
    notifyListeners();
  }

  /// Actualizar los atributos del botón temporal
  void updateButtonAttributes({
    String? text,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    bool? isBorder,
    Document? document,
  }) {
    if (_temporaryButton != null) {
      _temporaryButton = _temporaryButton!.copyWith(
        text: text ?? _temporaryButton!.text,
        isBold: isBold ?? _temporaryButton!.isBold,
        isItalic: isItalic ?? _temporaryButton!.isItalic,
        isUnderline: isUnderline ?? _temporaryButton!.isUnderline,
        isBorder: isBorder ?? _temporaryButton!.isBorder,
        document: document ?? _temporaryButton!.document,
      );
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
        if (_factoryButtons.isNotEmpty) {
          selectButton(0); // Seleccionar el primer botón como predeterminado
        }
      });
    }
  }
}
