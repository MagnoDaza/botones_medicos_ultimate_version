// Clase GridPage
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable_box/selectable_box.dart';

import '../botones/button_data/button_data.dart';
import '../controller/button_model.dart';

class GridPage extends StatefulWidget {
  final ButtonModel buttonModel;
  final ButtonType? selectedButtonType;
  final String currentText; // Nuevo argumento para el texto actual

  const GridPage({
    required this.buttonModel,
    this.selectedButtonType,
    required this.currentText, // Inicializar el nuevo argumento
  });

  @override
  _GridPageState createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.buttonModel.initializeButtons();
      _setInitialSelection();
    });
  }

  void _setInitialSelection() {
    if (widget.selectedButtonType != null) {
      final index = widget.buttonModel.factoryButtons.indexWhere(
        (button) => button.type == widget.selectedButtonType,
      );
      if (index != -1) {
        setState(() {
          _selectedIndex = index;
        });
      }
    } else if (widget.buttonModel.temporaryButton != null) {
      final index = widget.buttonModel.factoryButtons.indexWhere(
        (button) => button.type == widget.buttonModel.temporaryButton!.type,
      );
      if (index != -1) {
        setState(() {
          _selectedIndex = index;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un tipo de botón'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _selectedIndex != null
                ? () {
                    Navigator.pop(context, _selectedIndex);
                  }
                : null,
          ),
        ],
      ),
      body: Consumer<ButtonModel>(
        builder: (context, buttonModel, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: buttonModel.factoryButtons.length,
              itemBuilder: (context, index) {
                final buttonData = buttonModel.factoryButtons[index];
                return SelectableBox(
                  height: 180,
                  isSelected: _selectedIndex == index,
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    final selectedButtonData = buttonModel.factoryButtons[index];
                    final currentText = widget.currentText; // Usar el texto actual del widget
                    buttonModel.createNewButton(selectedButtonData.type, currentText); // Mantener el texto actual
                    Navigator.pop(context, index);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buttonData.build(context),
                      const SizedBox(height: 10),
                      Text(
                        buttonData.type.toString().split('.').last,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}