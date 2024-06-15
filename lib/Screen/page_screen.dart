import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import '../botones/boton/button_factory.dart';
import '../botones/button_data.dart';
import '../botones/quill/quill_page.dart';
import '../controller/button_model.dart';
import '../controller/color_notifier.dart';
import '../controller/text_style_notifier.dart';
import '../controller/theme_notifier.dart';
import '../preview_button.dart';
import '../widget/button_options.dart';

class ButtonPage extends StatefulWidget {
  final ButtonData? buttonData; // ButtonData opcional para edición

  const ButtonPage({super.key, this.buttonData});

  @override
  ButtonPageState createState() => ButtonPageState();
}

class ButtonPageState extends State<ButtonPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _buttonTextController = TextEditingController();
  late QuillController _controller;
  late ButtonFactory buttonFactory;
  String message = '';
  bool isReadOnly = false;
  bool isEditing = false; // Nuevo flag para edición

  @override
  void initState() {
    super.initState();
    buttonFactory = ButtonFactory(
      Provider.of<ColorNotifier>(context, listen: false),
      Provider.of<TextStyleNotifier>(context, listen: false),
    );
    // Determinar si estamos editando un botón existente
    isEditing = widget.buttonData != null;
    if (isEditing) {
      _buttonTextController.text = widget.buttonData!.text;
      _controller = QuillController(
        document: widget.buttonData!.document,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _buttonTextController.text = 'Servicio';
      _controller = QuillController.basic();
    }
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && !isEditing) {
        setState(() {
          _buttonTextController.text = '';
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final buttonModel = Provider.of<ButtonModel>(context, listen: false);
      if (!isEditing) {
        buttonModel.initializeButtons(
          buttonFactory,
          _buttonTextController,
          _controller,
        );
      } else {
        int index = buttonModel.savedButtons
            .indexWhere((button) => button.id == widget.buttonData!.id);
        if (index != -1) {
          buttonModel.selectButton(index);
        }
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _buttonTextController.dispose();
    super.dispose();
  }

  void updateButtonAttributes(Map<String, dynamic> newValues) {
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
    final buttonModel = Provider.of<ButtonModel>(context, listen: false);
    final selectedButton =
        buttonModel.factoryButtons[buttonModel.selectedIndex];
    if (isEditing) {
      // Actualizar el botón existente
      buttonModel.updateButton(
          buttonModel.selectedIndex,
          buttonFactory.updateButton(widget.buttonData!, {
            'text': _buttonTextController.text,
            // Asegúrate de incluir todos los atributos que se pueden editar
          }));
    } else {
      // Crear un nuevo botón
      final newButton = buttonFactory.createButton(
          selectedButton.type, _buttonTextController.text, _controller.document

          // Parámetros para crear un nuevo botón
          );
      buttonModel.saveButton(newButton);
    }
    Navigator.of(context)
        .pop(); // Regresar a la página anterior después de guardar
  }

  // Método para editar los atributos del botón y actualizar el JSON
  void editButtonAttributes(Map<String, dynamic> newAttributes) {
    final buttonModel = Provider.of<ButtonModel>(context, listen: false);
    ButtonData currentButton =
        buttonModel.factoryButtons[buttonModel.selectedIndex];

    // Actualizar los atributos del botón
    ButtonData updatedButton = currentButton.copyWith(
      text: newAttributes['text'],
      isBold: newAttributes['isBold'],
      isItalic: newAttributes['isItalic'],
      isUnderline: newAttributes['isUnderline'],
      isBorder: newAttributes['isBorder'],
      // Asegúrate de incluir todos los atributos que se pueden editar
    );

    // Actualizar el botón en el modelo
    buttonModel.updateButton(buttonModel.selectedIndex, updatedButton);

    // Serializar el botón actualizado a JSON
    Map<String, dynamic> json = updatedButton.toJson();

    // Aquí podrías guardar el JSON en una base de datos o en el estado de la aplicación
  }

  // Método para inicializar los atributos del botón desde JSON
  void initializeButtonFromJson(Map<String, dynamic> json) {
    ButtonData buttonFromJson = ButtonData.fromJson(json);
    final buttonModel = Provider.of<ButtonModel>(context, listen: false);
    buttonModel.addButton(buttonFromJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Botón' : 'Crear Botón'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              saveButton();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 160,
                child: ButtonPreview(
                  controller: _buttonTextController,
                  textStyleNotifier: Provider.of<TextStyleNotifier>(context),
                  buttonData:
                      widget.buttonData, // Pasar el buttonData si está editando
                  quillController: isEditing
                      ? _controller
                      : null, // Pasar el quillController si está editando
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'Opciones de los botones',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        leading: const Icon(Icons.description),
                        title: const Text('Contenido'),
                        trailing: ElevatedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    QuillPage(controller: _controller),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                _controller = QuillController(
                                  document: Document.fromJson(result),
                                  selection:
                                      const TextSelection.collapsed(offset: 0),
                                );
                              });
                            }
                          },
                          label: const Text('Nuevo'),
                          icon: const Icon(Icons.description),
                        ),
                      ),
                      ButtonOptions(
                        textStyleNotifier:
                            Provider.of<TextStyleNotifier>(context),
                        buttonTextController: _buttonTextController,
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
      ),
    );
  }
}
