import 'package:botones_medicos_ultimate_version/botones/button_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'botones/patron_builder/button_builder.dart';
import 'botones/widget/expansion_panel/controller_expansion_panel.dart';
import 'controller/button_model.dart';
import 'controller/button_name_notifier.dart';
import 'controller/color_notifier.dart';
import 'controller/text_style_notifier.dart';
import 'controller/theme_notifier.dart';
import 'Screen/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ColorNotifier()),
        ChangeNotifierProvider(create: (context) => TextStyleNotifier()),
        ChangeNotifierProvider(create: (context) => ButtonNameNotifier()),
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
        ChangeNotifierProvider(create: (context) => ExpansionPanelController()),
        ChangeNotifierProvider(create: (context) => ButtonModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: theme.isLightTheme
            ? ThemeData.light(useMaterial3: true)
            : ThemeData.dark(useMaterial3: true),
        home: HomePage(),
      ),
    );
  }
}
