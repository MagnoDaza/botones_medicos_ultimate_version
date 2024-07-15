import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/button_model.dart';

class OrderButtons extends StatefulWidget {
  const OrderButtons({super.key});

  @override
  _OrderButtonsState createState() => _OrderButtonsState();
}

class _OrderButtonsState extends State<OrderButtons> {
  @override
  Widget build(BuildContext context) {
    final buttonModel = Provider.of<ButtonModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reordenar Botones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // No es necesario hacer nada adicional aquí,
              // los cambios ya se han guardado en el modelo.
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          buttonModel.reorderButtons(oldIndex, newIndex);
        },
        children: [
          for (final button in buttonModel.savedButtons)
            ListTile(
              key: ValueKey(button.id),
              title: Text(
                  '${button.text} (${button.type.toString().split('.').last})'),
              trailing: const Icon(Icons.drag_handle),
            ),
        ],
      ),
    );
  }
}
