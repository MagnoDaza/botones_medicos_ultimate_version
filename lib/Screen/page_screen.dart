import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import '../botones/boton/button_factory.dart';
import '../botones/quill/quill_page.dart';
import '../botones/widget/expansion_panel/custom_expansion_panel.dart';
import '../common/refresh_indicator.dart';
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
              setState(() {
                message =
                    'Se ha creado un nuevo botón con el texto ${_buttonTextController.text}';
                _buttonTextController.text = '';
                final buttonModel =
                    Provider.of<ButtonModel>(context, listen: false);
                buttonModel.resetButton();
              });
            },
          ),
        ],
      ),
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
            TextFormField(
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
            SingleChildScrollView(
              child: Column(
                children: [
                  //texto de tamaño h2 que dice "opciones de los botones"
                  const Text(
                    'Opciones de los botones',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  ButtonOptions(
                    textStyleNotifier: Provider.of<TextStyleNotifier>(context),
                    buttonTextController: _buttonTextController,
                  ),
                  const SizedBox(height: 10),
                  CustomExpansionPanel(
                    items: [
                      PanelItem(
                        leading: const Icon(Icons.text_snippet),
                        headerValue: "Texto",
                        expandedValue: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //texto de tamaño h3 que dice "ingresar texto"
                              const Text(
                                "Ingresar texto",
                                style: TextStyle(fontSize: 20),
                              ),
                              ElevatedButton(
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
                                child: const Text('Ingresar texto'),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),

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
                        setState(() {
                          message =
                              'Se ha creado un nuevo botón con el texto ${_buttonTextController.text}';
                          //el texto del _buttonTextController.text se muestra en el mensaje como vacio entre comillar ""
                          _buttonTextController.text = '';
                          // Reset the selected button to the default button.
                          final buttonModel =
                              Provider.of<ButtonModel>(context, listen: false);
                          buttonModel
                              .resetButton(); // Reset the selected button to the default button.
                        });
                      }
                    },
                  ),
                  Text(message),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
