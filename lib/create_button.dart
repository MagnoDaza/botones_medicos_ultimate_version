import 'package:flutter/material.dart';

import 'Screen/page_screen.dart';

class CreateButton extends StatelessWidget {
  const CreateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Crear Botón'),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ButtonPage()),
        );
      },
    );
  }
}
