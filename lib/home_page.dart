import 'package:botones_medicos_ultimate_version/botones/button_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screen/page_screen.dart';
import 'controller/button_model.dart';
import 'controller/theme_notifier.dart';
import 'widget/button_grid.dart';

class HomePage extends StatelessWidget {
  HomePage({
    super.key,
  });

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
            ListTile(
              title: const Text("Crear Botón"),
              trailing: ElevatedButton.icon(
                label: const Text('Nuevo'),
                icon: const Icon(Icons.add),
                onPressed: () {
                  // Provider.of<ButtonModel>(context, listen: false)
                  //     .createNewButton();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ButtonPage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
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
              builder: (context, buttonModel, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: buttonModel.savedButtons.length,
                  itemBuilder: (context, index) {
                    final button = buttonModel.savedButtons[index];
                    return ListTile(
                      title: Text(
                          '${button.text} (${button.type.toString().split('.').last})'), // Mostrar tipo de botón junto al nombre
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ButtonPage(buttonData: button),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
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
