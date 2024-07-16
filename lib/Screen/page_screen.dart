import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import '../botones/button_data.dart';
import '../botones/patron_builder/button_builder.dart';
import '../botones/quill/quill_page.dart';
import '../controller/button_model.dart';
import '../controller/text_style_notifier.dart';
import '../controller/theme_notifier.dart';
import '../preview_button.dart';
import '../widget/button_options.dart';
import 'button_grid_widget.dart';

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
  String message = '';
  bool isEditing = false;
  ButtonType? selectedButtonType;

  @override
  void initState() {
    super.initState();
    isEditing = widget.buttonData != null;
    if (isEditing) {
      _buttonTextController.text = widget.buttonData!.text;
      _controller = QuillController(
        document: widget.buttonData!.document,
        selection: const TextSelection.collapsed(offset: 0),
      );
      selectedButtonType = widget.buttonData!.type;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final buttonModel = Provider.of<ButtonModel>(context, listen: false);
        final textStyleNotifier =
            Provider.of<TextStyleNotifier>(context, listen: false);
        int index = buttonModel.savedButtons
            .indexWhere((button) => button.id == widget.buttonData!.id);
        if (index != -1) {
          buttonModel.selectSavedButton(index);
          final selectedButton = buttonModel.savedButtons[index];
          textStyleNotifier.isBold = selectedButton.isBold;
          textStyleNotifier.isItalic = selectedButton.isItalic;
          textStyleNotifier.isUnderline = selectedButton.isUnderline;
          textStyleNotifier.isBorder = selectedButton.isBorder;
        }
      });
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
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _buttonTextController.dispose();
    super.dispose();
  }

  void updateButtonAttributes(Map<String, dynamic> newValues) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final buttonModel = Provider.of<ButtonModel>(context, listen: false);
      if (buttonModel.temporaryButton != null) {
        final updatedButton = ButtonBuilder()
            .fromButtonData(buttonModel.temporaryButton!)
            .setText(newValues['text'] ?? buttonModel.temporaryButton!.text)
            .setBold(newValues['isBold'] ?? buttonModel.temporaryButton!.isBold)
            .setItalic(
                newValues['isItalic'] ?? buttonModel.temporaryButton!.isItalic)
            .setUnderline(newValues['isUnderline'] ??
                buttonModel.temporaryButton!.isUnderline)
            .setBorder(
                newValues['isBorder'] ?? buttonModel.temporaryButton!.isBorder)
            .setDocument(
                newValues['document'] ?? buttonModel.temporaryButton!.document)
            .build();
        buttonModel.updateButton(updatedButton);
      }
    });
  }

  void saveButton() {
    final buttonModel = Provider.of<ButtonModel>(context, listen: false);
    if (buttonModel.temporaryButton != null) {
      if (isEditing) {
        buttonModel.updateExistingButton();
      } else {
        buttonModel.saveNewButton();
      }
      setState(() {
        message =
            'Se ha ${isEditing ? 'editado' : 'creado'} un nuevo botón con el texto ${_buttonTextController.text}';
        if (!isEditing) {
          _buttonTextController.text = '';
          selectedButtonType = null;
        }
      });
      Navigator.of(context).pop();
    } else {
      setState(() {
        message = 'No hay botones disponibles para guardar.';
      });
    }
  }

  Future<void> _selectButtonType() async {
    final selectedIndex = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => GridPage(
          buttonModel: Provider.of<ButtonModel>(context, listen: false),
          selectedButtonType: selectedButtonType,
        ),
      ),
    );

    if (selectedIndex != null) {
      setState(() {
        final buttonModel = Provider.of<ButtonModel>(context, listen: false);
        final newType = buttonModel.factoryButtons[selectedIndex].type;
        buttonModel.moveButtonDataToNewType(newType);
        selectedButtonType = newType;
        _buttonTextController.text = buttonModel.temporaryButton?.text ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonModel = Provider.of<ButtonModel>(context);
    final selectedButton = buttonModel.temporaryButton;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Botón' : 'Crear Botón'),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeNotifier>(context).isLightTheme
                  ? Icons.brightness_7 // ícono para el tema claro
                  : Icons.brightness_3, // ícono para el tema oscuro
            ),
            onPressed: () {
              // Cambia el tema
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
          child: Center(
            child: selectedButtonType == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Selecciona un tipo de botón'),
                      ElevatedButton(
                        onPressed: _selectButtonType,
                        child: const Text('Seleccionar tipo de botón'),
                      ),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      SizedBox(
                        height: 160,
                        child: PreviewButton(
                          controller: _buttonTextController,
                          textStyleNotifier:
                              Provider.of<TextStyleNotifier>(context),
                          buttonData: selectedButton,
                          quillController: _controller,
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
                          // Verificar el estado para evitar interferencias
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            updateButtonAttributes({'text': text});
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      if (selectedButtonType != null)
                        ListTile(
                          title: const Text('Selecciona un botón'),
                          trailing: ElevatedButton(
                            onPressed: _selectButtonType,
                            child: Text(
                              selectedButton?.type.toString().split('.').last ??
                                  'Seleccionar tipo de botón',
                            ),
                          ),
                        ),
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
                                updateButtonAttributes(
                                    {'document': _controller.document});
                              });
                            }
                          },
                          label: const Text('Nuevo'),
                          icon: const Icon(Icons.description),
                        ),
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
                              ButtonOptions(
                                textStyleNotifier:
                                    Provider.of<TextStyleNotifier>(context),
                                buttonTextController: _buttonTextController,
                                selectedButtonType: selectedButtonType,
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
      ),
    );
  }
}
