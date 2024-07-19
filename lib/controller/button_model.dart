
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:uuid/uuid.dart';
import '../botones/button_data/button_data.dart';
import '../botones/bottons_builder/button_builder.dart';


// Modelo de ButtonModel
class ButtonModel with ChangeNotifier {
  final List<ButtonData> _factoryButtons = [];
  final List<ButtonData> _savedButtons = [];
  final String _defaultText = 'Servicio';
  int _selectedIndex = -1;
  bool _buttonsInitialized = false;
  ButtonData? _temporaryButton; // Nueva instancia temporal para edición
  bool _isLoading = false;

  List<ButtonData> get factoryButtons => List.unmodifiable(_factoryButtons);
  int get selectedIndex => _selectedIndex;
  List<ButtonData> get savedButtons => List.unmodifiable(_savedButtons);
  bool get buttonsInitialized => _buttonsInitialized;
  ButtonData? get temporaryButton => _temporaryButton; // Obtener la instancia temporal
  bool get isLoading => _isLoading;

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void addButton(ButtonData buttonData) {
    _factoryButtons.add(buttonData);
    notifyListeners();
  }

  void saveNewButton() {
    if (_temporaryButton == null) return;
    _temporaryButton = _temporaryButton!.copyWith(id: const Uuid().v4());
    _savedButtons.add(_temporaryButton!);
    _temporaryButton = null;
    notifyListeners();
  }

  void updateExistingButton() {
    if (_temporaryButton == null) return;
    final index = _savedButtons.indexWhere((button) => button.id == _temporaryButton!.id);
    if (index != -1) {
      _savedButtons[index] = _temporaryButton!;
    }
    _temporaryButton = null;
    notifyListeners();
  }

  void selectButton(int index) {
    if (index >= 0 && index < _factoryButtons.length) {
      _selectedIndex = index;
      _temporaryButton = ButtonBuilder().fromButtonData(_factoryButtons[index]).build();
      notifyListeners();
    }
  }

  void selectSavedButton(int index) {
    if (index >= 0 && index < _savedButtons.length) {
      _selectedIndex = index;
      _temporaryButton = ButtonBuilder().fromButtonData(_savedButtons[index]).build();
      notifyListeners();
    }
  }

  void updateButton(ButtonData updatedButton) {
    if (_temporaryButton != null && _temporaryButton!.id == updatedButton.id) {
      _temporaryButton = updatedButton;
      notifyListeners();
    }
  }

  void setTemporaryButton(ButtonData button) {
    _temporaryButton = ButtonBuilder().fromButtonData(button).build();
    notifyListeners();
  }

  void removeButton(int index) {
    if (index >= 0 && index < _savedButtons.length) {
      _savedButtons.removeAt(index);
      notifyListeners();
    }
  }

  void createNewButton(ButtonType type, String currentText) {
    final newButton = ButtonBuilder()
        .setType(type)
        .setText(currentText)
        .setDocument(Document())
        .build();
    _temporaryButton = newButton;
    notifyListeners();
  }

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

  void cloneText(String buttonText,
      {bool? isBold,
      bool? isItalic,
      bool? isUnderline,
      bool? isBorder,
      Document? document}) {
    if (_temporaryButton != null) {
      _temporaryButton = _temporaryButton!.copyWith(
        id: const Uuid().v4(),
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

  void updateButtonTextStyle(
      bool isBold, bool isItalic, bool isUnderline, bool isBorder) {
    if (_temporaryButton != null) {
      _temporaryButton = _temporaryButton!.copyWith(
        id: const Uuid().v4(),
        isBold: isBold,
        isItalic: isItalic,
        isUnderline: isUnderline,
        isBorder: isBorder,
      );
      notifyListeners();
    }
  }

  void resetTemporaryButton() {
    _temporaryButton = null;
    notifyListeners();
  }

  void updateButtonAttributes({
    String? text,
    ButtonType? type,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    bool? isBorder,
    Document? document,
  }) {
    if (_temporaryButton != null) {
      _temporaryButton = _temporaryButton!.copyWith(
          id: const Uuid().v4(),
          text: text ?? _temporaryButton!.text,
          isBold: isBold ?? _temporaryButton!.isBold,
          isItalic: isItalic ?? _temporaryButton!.isItalic,
          isUnderline: isUnderline ?? _temporaryButton!.isUnderline,
          isBorder: isBorder ?? _temporaryButton!.isBorder,
          document: document ?? _temporaryButton!.document);
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

  void reorderButtons(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final ButtonData button = _savedButtons.removeAt(oldIndex);
    _savedButtons.insert(newIndex, button);
    notifyListeners();
  }

  void toggleButtonVisibility(int index) {
    if (index >= 0 && index < _savedButtons.length) {
      final button = _savedButtons[index];
      _savedButtons[index] = button.copyWith(
        id: button.id,
        isHidden: !button.isHidden,
      );
      notifyListeners();
    }
  }

  void moveButtonDataToNewType(ButtonType newType) {
    if (_temporaryButton != null) {
      _temporaryButton = ButtonBuilder()
          .fromButtonData(_temporaryButton!)
          .setType(newType)
          .build();
      notifyListeners();
    }
  }
}