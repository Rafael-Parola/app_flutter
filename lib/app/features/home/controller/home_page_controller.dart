import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePageController {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<Map<String, dynamic>>> loadSchedules() async {
    final storedData = await _storage.read(key: "medication_schedules");
    if (storedData != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(storedData));
    }
    return [];
  }

  Future<void> deleteSchedule(
      List<Map<String, dynamic>> schedules, int id) async {
    schedules.removeWhere((schedule) => schedule["id"] == id);
    await _storage.write(
        key: "medication_schedules", value: jsonEncode(schedules));
  }
}
