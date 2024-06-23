import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable_box/selectable_box.dart';
import '../controller/button_model.dart';

class GridPage extends StatefulWidget {
  final ButtonModel buttonModel;

  GridPage({required this.buttonModel});

  @override
  _GridPageState createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  int? _selectedIndex;

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
                : null, // Solo habilitado si hay un botón seleccionado
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Dos columnas
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: widget.buttonModel.factoryButtons.length,
          itemBuilder: (context, index) {
            final buttonData = widget.buttonModel.factoryButtons[index];
            return SelectableBox(
              height: 180,
              isSelected: _selectedIndex == index,
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Column(
                children: [
                  buttonData.build(context), // Previsualización del botón
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
      ),
    );
  }
}
