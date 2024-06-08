// test/button_model_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import '../botones/button_data.dart';
import '../controller/button_model.dart';
import '../controller/color_notifier.dart';
import '../controller/text_style_notifier.dart';

void main() {
  testWidgets('Button initialization does not duplicate buttons',
      (WidgetTester tester) async {
    final buttonFactory = ButtonFactory(
      ColorNotifier(),
      TextStyleNotifier(),
    );
    final buttonModel = ButtonModel(buttonFactory);

    await tester.pumpWidget(
      ChangeNotifierProvider<ButtonModel>.value(
        value: buttonModel,
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    buttonModel.initializeButtons(
                      buttonFactory,
                      TextEditingController(text: 'Servicio'),
                    );
                  },
                  child: const Text('Initialize Buttons'),
                );
              },
            ),
          ),
        ),
      ),
    );

    // First initialization
    await tester.tap(find.text('Initialize Buttons'));
    await tester.pump();
    expect(buttonModel.factoryButtons.length, ButtonType.values.length);

    // Attempt to reinitialize
    await tester.tap(find.text('Initialize Buttons'));
    await tester.pump();
    expect(buttonModel.factoryButtons.length, ButtonType.values.length);
  });
}
