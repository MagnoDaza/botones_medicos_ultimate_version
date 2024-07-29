import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:uuid/uuid.dart';
import '../botones/button_data/button_data.dart';
import '../botones/bottons_builder/button_builder.dart';
import '../controller/text_style_notifier.dart';

class ButtonModel with ChangeNotifier {
  final List<ButtonData> _factoryButtons = [];
  final List<ButtonData> _savedButtons = [];
  final String _defaultText = 'Servicio';
  int _selectedIndex = -1;
  bool _buttonsInitialized = false;
  ButtonData? _temporaryButton;
  bool _isLoading = false;

  List<ButtonData> get factoryButtons => List.unmodifiable(_factoryButtons);
  int get selectedIndex => _selectedIndex;
  List<ButtonData> get savedButtons => List.unmodifiable(_savedButtons);
  bool get buttonsInitialized => _buttonsInitialized;
  ButtonData? get temporaryButton => _temporaryButton;
  bool get isLoading => _isLoading;

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void addButton(ButtonData buttonData) {
    _factoryButtons.add(buttonData);
    notifyListeners();
  }

  void saveNewButton(TextStyleNotifier textStyleNotifier) {
    if (_temporaryButton == null) return;
    _temporaryButton = _temporaryButton!.copyWith(id: const Uuid().v4());
    _savedButtons.add(_temporaryButton!);
    _temporaryButton = null;
    textStyleNotifier.resetTextStyle();
    notifyListeners();
  }

  void updateExistingButton(TextStyleNotifier textStyleNotifier) {
    if (_temporaryButton == null) return;
    final index = _savedButtons.indexWhere((button) => button.id == _temporaryButton!.id);
    if (index != -1) {
      _savedButtons[index] = _temporaryButton!;
    }
    _temporaryButton = null;
    textStyleNotifier.resetTextStyle();
    notifyListeners();
  }

  void selectButton(int index) {
    if (index >= 0 && index < _factoryButtons.length) {
      _selectedIndex = index;
      _temporaryButton = ButtonBuilder().fromButtonData(_factoryButtons[index]).build();
      notifyListeners();
    }
  }

  void selectSavedButton(int index, TextStyleNotifier textStyleNotifier) {
    if (index >= 0 && index < _savedButtons.length) {
      _selectedIndex = index;
      _temporaryButton = ButtonBuilder().fromButtonData(_savedButtons[index]).build();
      notifyListeners();
      _updateTextStyleNotifier(textStyleNotifier);
    }
  }

  void updateButton(ButtonData updatedButton) {
    if (_temporaryButton != null && _temporaryButton!.id == updatedButton.id) {
      _temporaryButton = updatedButton;
      notifyListeners();
    }
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
      .setBold(false)
      .setItalic(false)
      .setUnderline(false)
      .setBorder(false)
      .build();
    _temporaryButton = newButton;
    notifyListeners();
  }

  void initializeButtons() {
    if (!_buttonsInitialized) {
      final List<ButtonData> buttons = [];
      for (ButtonType type in ButtonType.values) {
        buttons.add(ButtonBuilder()
          .setType(type)
          .setText(_defaultText)
          .setDocument(Document())
          .setBold(false)
          .setItalic(false)
          .setUnderline(false)
          .setBorder(false)
          .build());
      }
      _factoryButtons.addAll(buttons);
      _buttonsInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_factoryButtons.isNotEmpty) {
          selectButton(0);
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

  void _updateTextStyleNotifier(TextStyleNotifier textStyleNotifier) {
    if (_temporaryButton != null) {
      textStyleNotifier.updateTextStyle(
        isBold: _temporaryButton!.isBold,
        isItalic: _temporaryButton!.isItalic,
        isUnderline: _temporaryButton!.isUnderline,
        isBorder: _temporaryButton!.isBorder,
      );
    }
  }
}
