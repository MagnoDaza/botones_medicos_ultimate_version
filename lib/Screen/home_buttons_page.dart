import 'package:botones_medicos_ultimate_version/screen/order_buttons_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'button_page.dart';
import '../controller/button_model.dart';
import '../controller/theme_notifier.dart';
import '../widget/grid_button/button_grid.dart';

import 'togle_visibility_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(
                Provider.of<ThemeNotifier>(context).isLightTheme
                    ? Icons.brightness_7 // ícono para el tema claro
                    : Icons.brightness_3, // ícono para el tema oscuro
              ),
              onPressed: () {
                // Cambia el tema
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ButtonPage()),
                  );
                },
              ),
            ),
            ListTile(
              title: const Text("Organizar botones"),
              trailing: ElevatedButton.icon(
                label: const Text('Organizar'),
                icon: const Icon(Icons.sort),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OrderButtons()),
                  );
                },
              ),
            ),
            ListTile(
              title: const Text("Ocultar/Mostrar Botones"),
              trailing: ElevatedButton.icon(
                label: const Text('Ocultar/Mostrar'),
                icon: const Icon(Icons.visibility),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ToggleVisibilityPage()),
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
                          '${button.text} (${button.type.toString().split('.').last})'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Convierte el botón a JSON y lo imprime
                              final buttonJson = (button.toJson());
                              print('Editando botón: $buttonJson');
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
                          if (button.isHidden) const Icon(Icons.visibility_off),
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
