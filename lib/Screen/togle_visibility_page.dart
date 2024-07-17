import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/button_model.dart';

class ToggleVisibilityPage extends StatelessWidget {
  const ToggleVisibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonModel = Provider.of<ButtonModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ocultar/Mostrar Botones'),
      ),
      body: buttonModel.savedButtons.isEmpty
          ? const Center(
              child: Text(
                'Aún no hay botones para mostrar',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: buttonModel.savedButtons.length,
              itemBuilder: (context, index) {
                final button = buttonModel.savedButtons[index];
                return ListTile(
                  title: Text(
                      '${button.text} (${button.type.toString().split('.').last})'),
                  trailing: Switch(
                    value: !button.isHidden,
                    onChanged: (value) {
                      buttonModel.toggleButtonVisibility(index);
                    },
                  ),
                );
              },
            ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../controller/button_model.dart';

// class ToggleVisibilityPage extends StatelessWidget {
//   const ToggleVisibilityPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final buttonModel = Provider.of<ButtonModel>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Ocultar/Mostrar Botones'),
//       ),
//       body: buttonModel.savedButtons.isEmpty
//           ? Center(
//               child: Text(
//                 'Aún no hay botones para mostrar',
//                 style: TextStyle(fontSize: 18),
//               ),
//             )
//           : ListView.builder(
//               itemCount: buttonModel.savedButtons.length,
//               itemBuilder: (context, index) {
//                 final button = buttonModel.savedButtons[index];
//                 return ListTile(
//                   title: Text('${button.text} (${button.type.toString().split('.').last})'),
//                   trailing: GestureDetector(
//                     onTap: () {
//                       buttonModel.toggleButtonVisibility(index);
//                     },
//                     child: AnimatedSwitcher(
//                       duration: Duration(milliseconds: 300),
//                       transitionBuilder: (Widget child, Animation<double> animation) {
//                         return ScaleTransition(child: child, scale: animation);
//                       },
//                       child: button.isHidden
//                           ? Icon(Icons.visibility_off, key: ValueKey('off'))
//                           : Icon(Icons.visibility, key: ValueKey('on')),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
