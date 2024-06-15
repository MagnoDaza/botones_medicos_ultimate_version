import 'package:botones_medicos_ultimate_version/botones/boton/elevated_button_data.dart';
import 'package:botones_medicos_ultimate_version/botones/button_data.dart';
import 'package:botones_medicos_ultimate_version/repository/button_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter_quill/flutter_quill.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ButtonRepositoryImplement buttonRepository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    buttonRepository = ButtonRepositoryImplement();
    await buttonRepository.database;
  });

  test('saveButton and loadButtons', () async {
    final button = ElevatedButtonData(
      id: '1',
      type: ButtonType.elevated,
      text: 'Test Button',
      document: Document(),
      color: const Color(0xFFFFFFFF),
      textColor: const Color(0xFF000000),
      isBold: true,
      isItalic: false,
      isUnderline: true,
      isBorder: false,
    );

    await buttonRepository.saveButton(button);

    final loadedButtons = await buttonRepository.loadButtons(limit: 10, offset: 0);
    expect(loadedButtons.length, 1);
    expect(loadedButtons.first.text, 'Test Button');
  });

  test('updateButton', () async {
    final button = ElevatedButtonData(
      id: '1',
      type: ButtonType.elevated,
      text: 'Test Button',
      document: Document(),
      color: const Color(0xFFFFFFFF),
      textColor: const Color(0xFF000000),
      isBold: true,
      isItalic: false,
      isUnderline: true,
      isBorder: false,
    );

    await buttonRepository.saveButton(button);

    final updatedButton = button.copyWith(text: 'Updated Button');
    await buttonRepository.updateButton(updatedButton);

    final loadedButtons = await buttonRepository.loadButtons(limit: 10, offset: 0);
    expect(loadedButtons.first.text, 'Updated Button');
  });

  test('deleteButton', () async {
    final button = ElevatedButtonData(
      id: '1',
      type: ButtonType.elevated,
      text: 'Test Button',
      document: Document(),
      color: const Color(0xFFFFFFFF),
      textColor: const Color(0xFF000000),
      isBold: true,
      isItalic: false,
      isUnderline: true,
      isBorder: false,
    );

    await buttonRepository.saveButton(button);
    await buttonRepository.deleteButton(button.id);

    final loadedButtons = await buttonRepository.loadButtons(limit: 10, offset: 0);
    expect(loadedButtons.isEmpty, true);
  });
}
