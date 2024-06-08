import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../controller/button_model.dart';
import 'button_tile.dart';

class ButtonGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ButtonModel>(
      builder: (context, buttonModel, child) {
        // Comprueba si la lista de botones guardados está vacía
        if (buttonModel.savedButtons.isEmpty) {
          return const SizedBox(
            height: 133,
            child: Center(
              child: Text("Aún no has guardado botones de servicios"),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2.0),
          ),
          padding: const EdgeInsets.all(0),
          height: 133,
          child: MasonryGridView.builder(
            crossAxisSpacing: 1,
            itemCount: buttonModel.savedButtons.length, // Muestra todos los botones guardados
            itemBuilder: (BuildContext context, int index) => Container(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
              child: ButtonTile(
                button: buttonModel.savedButtons[index], // Muestra el botón guardado en el índice actual
              ),
            ),
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            scrollDirection: Axis.horizontal,
          ),
        );
      },
    );
  }
}
