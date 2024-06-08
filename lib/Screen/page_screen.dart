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
          buttonFactory, _buttonTextController, _controller);
    });
  }

  @override
  void dispose() {
    // Asegúrate de deshacerte del FocusNode cuando el widget se desmonte
    _focusNode.dispose();
    _buttonTextController.dispose();
    super.dispose();
  }

  void updateButtonAttributes(Map<String, dynamic> newValues) {
    //El setState se utiliza para actualizar el estado del widget y que se pueda clonar el texto del boton seleccionado
    setState(() {
      final selectedButton =
          Provider.of<ButtonModel>(context, listen: false).factoryButtons[
              Provider.of<ButtonModel>(context, listen: false).selectedIndex];

      final updatedButton =
          buttonFactory.updateButton(selectedButton, newValues);

      Provider.of<ButtonModel>(context, listen: false).updateButton(
        Provider.of<ButtonModel>(context, listen: false).selectedIndex,
        updatedButton,
      );
    });
  }

  void saveButton() {
    final buttonModel = Provider.of<ButtonModel>(context, listen: false);
    final selectedButton =
        buttonModel.factoryButtons[buttonModel.selectedIndex];

    buttonModel.saveButton(selectedButton);
    setState(() {
      message = 'Se ha guardado el botón: ${selectedButton.text}';
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
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 160,
              child: ButtonPreview(
                controller: _buttonTextController,
                textStyleNotifier: Provider.of<TextStyleNotifier>(context),
              ),
            ),
            ButtonOptions(
              textStyleNotifier: Provider.of<TextStyleNotifier>(context),
              buttonTextController: _buttonTextController,
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
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => QuillPage(controller: _controller),
                  ),
                )
                    .then((result) {
                  if (result != null) {
                    setState(() {
                      _controller.document = Document.fromJson(result);
                    });
                  }
                });
              },
              child: const Text('Ingresar texto'),
            ),
            ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () {
                if (_buttonTextController.text.isEmpty) {
                  setState(() {
                    message = 'Por favor, proporciona un texto para el botón.';
                  });
                } else {
                  saveButton();
                  setState(() {
                    message =
                        'Se ha creado un nuevo botón con el texto ${_buttonTextController.text}';
                    _buttonTextController.text = '';
                  });
                }
              },
            ),
            Text(message),
          ],
        ),
      ),
    );
  }
}
