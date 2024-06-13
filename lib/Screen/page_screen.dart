import 'package:botones_medicos_ultimate_version/botones/widget/expansion_panel/custom_expansion_panel.dart';
import 'package:botones_medicos_ultimate_version/botones/widget/rainbow_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import '../botones/boton/button_factory.dart';
import '../botones/quill/quill_page.dart';
import '../controller/button_model.dart';
import '../controller/color_notifier.dart';
import '../controller/text_style_notifier.dart';
import '../controller/theme_notifier.dart';
import '../preview_button.dart';
import '../widget/button_options.dart';

class ButtonPage extends StatefulWidget {
  const ButtonPage({super.key});

  @override
  ButtonPageState createState() => ButtonPageState();
}

class ButtonPageState extends State<ButtonPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _buttonTextController = TextEditingController();
  final QuillController _controller = QuillController.basic();
  late ButtonFactory buttonFactory;
  String message = '';
  bool isReadOnly = false;

  @override
  void initState() {
    super.initState();
    _controller.readOnly = isReadOnly;
    _buttonTextController.text = 'Servicio';
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _buttonTextController.text = '';
        });
      }
    });

    // Initialize the button factory
    buttonFactory = ButtonFactory(
      Provider.of<ColorNotifier>(context, listen: false),
      Provider.of<TextStyleNotifier>(context, listen: false),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final buttonModel = Provider.of<ButtonModel>(context, listen: false);
      buttonModel.initializeButtons(
        buttonFactory,
        _buttonTextController,
        _controller,
      );
    });
  }

  @override
  void dispose() {
    // Dispose the FocusNode and TextEditingController when the widget is removed from the widget tree.
    _focusNode.dispose();
    _buttonTextController.dispose();
    super.dispose();
  }

  void updateButtonAttributes(Map<String, dynamic> newValues) {
    // Update the state to reflect changes in button attributes.
    setState(() {
      final buttonModel = Provider.of<ButtonModel>(context, listen: false);
      final selectedButton =
          buttonModel.factoryButtons[buttonModel.selectedIndex];
      final updatedButton =
          buttonFactory.updateButton(selectedButton, newValues);

      buttonModel.updateButton(buttonModel.selectedIndex, updatedButton);
    });
  }

  void saveButton() {
    // Save the currently selected button and display a message.
    final buttonModel = Provider.of<ButtonModel>(context, listen: false);
    final selectedButton =
        buttonModel.factoryButtons[buttonModel.selectedIndex];

    buttonModel.saveButton(selectedButton);

    setState(() {
      message =
          'Se ha creado un nuevo botón con el texto ${_buttonTextController.text}';
      _buttonTextController.text = '';
      final buttonModel = Provider.of<ButtonModel>(context, listen: false);
      buttonModel.resetButton();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Botón'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
            },
          ),

          //ADD BUTTON FOR SAVE BUTTON
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              saveButton();
            },
          ),
        ],
      ),
      //boton flotante con el icono de guardar boton.
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_buttonTextController.text.isEmpty) {
              setState(() {
                message = 'Por favor, proporciona un texto para el botón.';
              });
            } else {
              saveButton();
            }
          },
          label: const Text("Guardar"),
          icon: const Icon(Icons.save)),
      //cuerpo de la aplicación
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 160,
              child: ButtonPreview(
                controller: _buttonTextController,
                textStyleNotifier: Provider.of<TextStyleNotifier>(context),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
              child: TextFormField(
                focusNode: _focusNode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Texto del botón',
                  hintText: 'Texto del botón',
                ),
                controller: _buttonTextController,
                onChanged: (text) {
                  updateButtonAttributes({'text': text});
                },
              ),
            ),
            SizedBox.fromSize(
              size: const Size.fromHeight(35),
              child: const Padding(
                padding: EdgeInsets.only(left: 24.0, top: 10),
                child: Text(
                  'Opciones de los botones',
                  style: TextStyle(
                    fontSize: 20,
                    decorationStyle: TextDecorationStyle.wavy,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    //Texto del quillcontroller.
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Row(
                            children: [
                              RainbowIcon(iconData: Icons.text_fields),
                              SizedBox(width: 8),
                              Text('Contenido del botón'),
                            ],
                          ),
                          // El texto
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      QuillPage(controller: _controller),
                                ),
                              )
                                  .then((result) {
                                if (result != null) {
                                  setState(() {
                                    _controller.document =
                                        Document.fromJson(result);
                                  });
                                }
                              });
                            },
                            icon: const Icon(Icons.add), // Icono del botón
                            label: const Text('Nuevo '), // Texto del botón
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    //opciones de los botones
                    ButtonOptions(
                      textStyleNotifier:
                          Provider.of<TextStyleNotifier>(context),
                      buttonTextController: _buttonTextController,
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      child: const Text('Guardar'),
                      onPressed: () {
                        if (_buttonTextController.text.isEmpty) {
                          setState(() {
                            message =
                                'Por favor, proporciona un texto para el botón.';
                          });
                        } else {
                          saveButton();
                          // setState(() {
                          //   message =
                          //       'Se ha creado un nuevo botón con el texto ${_buttonTextController.text}';
                          //   //el texto del _buttonTextController.text se muestra en el mensaje como vacio entre comillar ""
                          //   _buttonTextController.text = '';
                          //   // Reset the selected button to the default button.
                          //   final buttonModel = Provider.of<ButtonModel>(
                          //       context,
                          //       listen: false);
                          //   buttonModel
                          //       .resetButton(); // Reset the selected button to the default button.
                          // });
                        }
                      },
                    ),
                    Text(message),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
