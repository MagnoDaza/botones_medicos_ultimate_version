import '../botones/button_data.dart';

abstract class ButtonRepository {
  Future<void> saveButton(ButtonData buttonData);
  Future<List<ButtonData>> loadButtons({int limit, int offset});
  Future<void> deleteButton(String id);
  Future<void> updateButton(ButtonData buttonData);
}
