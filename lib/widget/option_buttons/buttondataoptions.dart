import 'package:flutter/material.dart';
import '../../controller/text_style_notifier.dart';

abstract class ButtonDataOptions extends StatelessWidget {
  final TextStyleNotifier textStyleNotifier;

  const ButtonDataOptions({Key? key, required this.textStyleNotifier}) : super(key: key);
}
