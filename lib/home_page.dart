import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/button_model.dart';
import 'controller/theme_notifier.dart';
import 'create_button.dart';
import 'widget/button_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: () {
                Provider.of<ThemeNotifier>(context, listen: false)
                    .toggleTheme();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Crear botón:"),
                CreateButton(),
              ],
            ),
            const SizedBox(height: 20), // Espacio entre elementos
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Mis botones",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Consumer<ButtonModel>(
              // Asumiendo que ButtonModel tiene la lista de botones
              builder: (context, buttonModel, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: buttonModel.savedButtons.length,
                  itemBuilder: (context, index) {
                    final button = buttonModel.savedButtons[index];
                    return ListTile(
                      title: Text(button.text),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Lógica para editar el botón
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Lógica para eliminar el botón
                              buttonModel.removeButton(index);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            ButtonGrid(),
          ],
        ),
      ),
    );
  }
}
