import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../button_data.dart';
import '../button_sheet.dart';

class OutlinedButtonData extends ButtonData {
  OutlinedButtonData({
    required ButtonType type,
    required String text,
    required Document document,
    required bool isBold,
    required bool isItalic,
    required bool isUnderline,
    required bool isBorder,
    required String id,
  }) : super(
          id: id,
          type: type,
          text: text,
          document: document,
          isBold: isBold,
          isItalic: isItalic,
          isBorder: isBorder,
          isUnderline: isUnderline,
        );

  @override
  Widget build(BuildContext context) {
    final Document document = this.document;
    final quillController = QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
    );
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        alignment: Alignment.center,
        shape: isBorder
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              )
            : null,
      ),
      onPressed: () {
        showCustomBottomSheet(
          context: context,
          controller: quillController,
          builder: (BuildContext context) {},
        );
      },
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).textTheme.displayMedium!.color,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          decoration:
              isUnderline ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }

  @override
  OutlinedButtonData cloneWithText({
    required String newText,
    required bool newIsBold,
    required bool newIsItalic,
    required bool newIsUnderline,
    required bool newIsBorder,
    required Document document,
  }) {
    return copyWith(
      text: newText,
      isBold: newIsBold,
      isItalic: newIsItalic,
      isUnderline: newIsUnderline,
      isBorder: newIsBorder,
      document:
          Document.fromJson(document.toDelta().toJson()), // Clonar el documento
    );
  }

  @override
  OutlinedButtonData copyWith({
    String? id,
    ButtonType? type,
    String? text,
    Document? document,
    Color? color,
    Color? textColor,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    bool? isBorder,
  }) {
    return OutlinedButtonData(
      id: id ?? this.id,
      type: type ?? this.type,
      text: text ?? this.text,
      document: document ?? this.document,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      isBorder: isBorder ?? this.isBorder,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }

  factory OutlinedButtonData.fromJson(Map<String, dynamic> json) {
    return OutlinedButtonData(
      id: json['id'],
      type: ButtonType.values.firstWhere((e) => e.toString() == json['type']),
      text: json['text'],
      document: Document.fromJson(json['document']),
      isBold: json['isBold'] == 1,
      isItalic: json['isItalic'] == 1,
      isUnderline: json['isUnderline'] == 1,
      isBorder: json['isBorder'] == 1,
    );
  }
}
