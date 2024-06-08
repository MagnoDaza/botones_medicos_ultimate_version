import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'botones/boton/button_factory.dart';
import 'controller/button_model.dart';
import 'controller/button_name_notifier.dart';
import 'controller/color_notifier.dart';
import 'controller/text_style_notifier.dart';
import 'controller/theme_notifier.dart';
import 'home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ColorNotifier()),
        ChangeNotifierProvider(create: (context) => TextStyleNotifier()),
        ChangeNotifierProvider(create: (context) => ButtonNameNotifier()),
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
        // Asegúrate de crear ButtonFactory antes de ButtonModel si es necesario
        ChangeNotifierProvider(
          create: (context) => ButtonModel(
            ButtonFactory(
              Provider.of<ColorNotifier>(context, listen: false),
              Provider.of<TextStyleNotifier>(context, listen: false),
            ),
          ),
        ),
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
        home: const HomePage(),
      ),
    );
  }
}
