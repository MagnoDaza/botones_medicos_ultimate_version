import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../button_data/button_data.dart';
import '../../widget/quill/button_sheet/button_sheet.dart';

// Clase para los datos del botón animado
class ColorfulButtonData extends ButtonData {
  ColorfulButtonData({
    required ButtonType type,
    required String text,
    required Document document,
    required bool isBold,
    required bool isItalic,
    required bool isUnderline,
    required bool isBorder,
    required String id,
    bool isHidden = false,
  }) : super(
          id: id,
          type: type,
          text: text,
          document: document,
          isBold: isBold,
          isItalic: isItalic,
          isUnderline: isUnderline,
          isBorder: isBorder,
          isHidden: isHidden,
        );

  @override
  Widget build(BuildContext context) {
    final Document document = this.document;
    final quillController = QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
    );

    return AnimatedButton(
      onPressed: () {
        showCustomBottomSheet(
          context: context,
          controller: quillController,
          builder: (BuildContext context) {},
        );
      },
      text: text,
      isBold: isBold,
      isItalic: isItalic,
      isUnderline: isUnderline,
      isBorder: isBorder,
    );
  }

  @override
  ColorfulButtonData copyWith({
    String? id,
    ButtonType? type,
    String? text,
    Document? document,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    bool? isBorder,
    bool? isHidden,
  }) {
    return ColorfulButtonData(
      id: id ?? this.id,
      type: type ?? this.type,
      text: text ?? this.text,
      document: document ?? this.document,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      isBorder: isBorder ?? this.isBorder,
      isHidden: isHidden ?? this.isHidden,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }

  factory ColorfulButtonData.fromJson(Map<String, dynamic> json) {
    return ColorfulButtonData(
      id: json['id'],
      type: ButtonType.values.firstWhere((e) => e.toString() == json['type']),
      text: json['text'],
      document: Document.fromJson(json['document']),
      isBold: json['isBold'] == 1,
      isItalic: json['isItalic'] == 1,
      isUnderline: json['isUnderline'] == 1,
      isBorder: json['isBorder'] == 1,
      isHidden: json['isHidden'] == 1,
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final bool isBorder;

  const AnimatedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.isBold,
    required this.isItalic,
    required this.isUnderline,
    required this.isBorder,
  }) : super(key: key);

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Tween<double> tween;
  late Animation<double> animation;

  @override
  void initState() {
    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    tween = Tween<double>(begin: 0, end: 359);
    animation = controller.drive(tween);
    controller.forward();
    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkTheme ? Colors.white : Colors.black;

    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return IntrinsicWidth(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: widget.isBorder
                    ? BorderRadius.circular(8)
                    : BorderRadius.circular(24),
                border: Border.all(
                  color: _getBorderColor(animation.value),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getBorderColor(animation.value).withOpacity(0.5),
                    offset: const Offset(-4, 4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: TextButton(
                onPressed: widget.onPressed,
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 40), // Altura fija
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16), // Espaciado horizontal
                  shape: RoundedRectangleBorder(
                    borderRadius: widget.isBorder
                        ? BorderRadius.circular(8)
                        : BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        widget.isBold ? FontWeight.bold : FontWeight.w300,
                    fontStyle:
                        widget.isItalic ? FontStyle.italic : FontStyle.normal,
                    decoration: widget.isUnderline
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    color: textColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getBorderColor(double value) {
    return HSVColor.fromAHSV(1.0, value, 1.0, 1.0).toColor();
  }
}
