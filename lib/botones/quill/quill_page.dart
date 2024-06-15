// quill_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QuillPage extends StatefulWidget {
  
  final QuillController controller;

  const QuillPage({super.key, required this.controller});

  @override
  _QuillPageState createState() => _QuillPageState();
}

class _QuillPageState extends State<QuillPage> {
  final List<Document> _documentVersions = [];
  Timer? _saveTimer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _saveTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 5), _saveDocument);
  }

  void _saveDocument() {
    _documentVersions
        .add(Document.fromJson(widget.controller.document.toDelta().toJson()));
    _notifyContentSaved(); // Llama a la nueva función aquí

    print('Documento guardado');
  }

  void _notifyContentSaved() {
    Fluttertoast.showToast(
        msg: "El contenido se ha guardado correctamente.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor de texto'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                // Llama a tu función de guardado aquí
                _saveDocument();

                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  QuillSimpleToolbar(
                    configurations: QuillSimpleToolbarConfigurations(
                      axis: Axis.horizontal,
                      controller: widget.controller,
                      headerStyleType: HeaderStyleType.buttons,
                      toolbarSectionSpacing: 8.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: QuillEditor.basic(
              scrollController: ScrollController(),
              configurations: QuillEditorConfigurations(
                enableInteractiveSelection: true,
                autoFocus: true,
                padding: const EdgeInsets.all(16.0),
                scrollable: true,
                controller: widget.controller,
                disableClipboard: false,
                elementOptions: const QuillEditorElementOptions(
                  orderedList: QuillEditorOrderedListElementOptions(
                    useTextColorForDot: true,
                  ),
                ),
              ),
              focusNode: FocusNode(),
            ),
          ),
        ],
      ),
    );
  }
}
