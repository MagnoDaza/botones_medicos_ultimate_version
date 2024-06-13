import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../botones/button_data.dart';

class ButtonRepository {
  static final ButtonRepository _instance = ButtonRepository._internal();
  factory ButtonRepository() => _instance;

  ButtonRepository._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'buttons.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE buttons(
            id TEXT PRIMARY KEY,
            type TEXT,
            text TEXT,
            document TEXT,
            isBold INTEGER,
            isItalic INTEGER,
            isUnderline INTEGER,
            isBorder INTEGER,
            color INTEGER,
            textColor INTEGER
          )
        ''');
      },
    );
  }

  Future<void> saveButton(ButtonData buttonData) async {
    final db = await database;
    await db.insert(
      'buttons',
      buttonData.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ButtonData>> loadButtons({int limit = 10, int offset = 0}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'buttons',
      limit: limit,
      offset: offset,
    );

    return List.generate(maps.length, (i) {
      return ButtonData.fromJson(maps[i]);
    });
  }

  Future<void> deleteButton(String id) async {
    final db = await database;
    await db.delete(
      'buttons',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateButton(ButtonData buttonData) async {
    final db = await database;
    await db.update(
      'buttons',
      buttonData.toJson(),
      where: 'id = ?',
      whereArgs: [buttonData.id],
    );
  }
}
