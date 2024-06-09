import 'package:flutter/material.dart';

// Clase que notifica a los widgets cuando cambia el color de un botón
class ColorNotifier with ChangeNotifier {
  final Map<String, Color> _buttonBackgroundColors = {};
  final Map<String, Color> _buttonTextColors = {};

  // Establece el color de fondo para un botón específico
  void setBackgroundColor(String buttonId, Color color) {
    _buttonBackgroundColors[buttonId] = color;
    notifyListeners();
  }

  // Establece el color de texto para un botón específico
  void setTextColor(String buttonId, Color color) {
    _buttonTextColors[buttonId] = color;
    notifyListeners();
  }

  // Obtiene el color de fondo para un botón específico
  Color getBackgroundColor(String buttonId) {
    return _buttonBackgroundColors[buttonId] ??
        const Color(0xFF4F4F4F); // Color por defecto
  }

  // Obtiene el color de texto para un botón específico
  Color getTextColor(String buttonId) {
    return _buttonTextColors[buttonId] ?? Colors.white; // Color por defecto
  }

  //reset colors
  void resetColors() {
    _buttonBackgroundColors.clear();
    _buttonTextColors.clear();
    notifyListeners();
  }

  //resetea el color del boton seleccionado, si el boton tiene colores
  void resetButtonColor(String buttonId) {
    _buttonBackgroundColors.remove(buttonId);
    _buttonTextColors.remove(buttonId);
    notifyListeners();
  }
}
