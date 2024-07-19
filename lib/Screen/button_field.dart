// Clase TextFormFieldDialog
import 'package:flutter/material.dart';

class TextFormFieldDialog extends StatelessWidget {
  final TextEditingController controller;

  const TextFormFieldDialog({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Texto'),
      content: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Texto del botón',
          hintText: 'Texto del botón',
        ),
        controller: controller,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(controller.text);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
