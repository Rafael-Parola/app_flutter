import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AddCalendarController extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  List<bool> selectedDays = List.generate(7, (index) => false);
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? selectedTime;

  final List<String> weekDays = [
    "Dom",
    "Seg",
    "Ter",
    "Qua",
    "Qui",
    "Sex",
    "Sáb"
  ];

  Future<void> selectDate(BuildContext context, bool isStart) async {
    DateTime initialDate =
        isStart ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      if (isStart) {
        startDate = picked;
      } else {
        endDate = picked;
      }
      notifyListeners();
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      selectedTime = picked;
      notifyListeners();
    }
  }

  void toggleDay(int index) {
    selectedDays[index] = !selectedDays[index];
    notifyListeners();
  }

  String getFormattedDate(DateTime? date) {
    return date == null
        ? "Selecionar data"
        : DateFormat("dd/MM/yyyy").format(date);
  }

  String getFormattedTime(BuildContext context) {
    return selectedTime == null
        ? "Selecionar horário"
        : selectedTime!.format(context);
  }

  Future<int> getNextScheduleId() async {
    final storedData = await _storage.read(key: "medication_schedules");
    List<dynamic> schedules = storedData != null ? jsonDecode(storedData) : [];
    return schedules.isEmpty ? 1 : schedules.last["id"] + 1;
  }

  Future<void> saveSchedule(BuildContext context) async {
    try {
      final newId = await getNextScheduleId();

      final newSchedule = {
        "id": newId,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "selectedTime": selectedTime != null
            ? {"hour": selectedTime!.hour, "minute": selectedTime!.minute}
            : null,
        "selectedDays": selectedDays,
      };

      final storedData = await _storage.read(key: "medication_schedules");
      List<dynamic> schedules =
          storedData != null ? jsonDecode(storedData) : [];

      schedules.add(newSchedule);
      await _storage.write(
          key: "medication_schedules", value: jsonEncode(schedules));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Agenda salva com sucesso!")),
      );

      logSavedSchedules();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar agenda: $e")),
      );
    }
  }

  Future<void> logSavedSchedules() async {
    final storedData = await _storage.read(key: "medication_schedules");

    if (storedData != null) {
      final List<dynamic> schedules = jsonDecode(storedData);

      log("📌 **Lista de Agendas Salvas:**");
      for (var schedule in schedules) {
        log("🔹 ID: ${schedule['id']}");
        log("🗓 Data de Início: ${schedule['startDate']}");
        log("🗓 Data de Término: ${schedule['endDate']}");
        log("⏰ Horário: ${schedule['selectedTime']}");
        log("📅 Dias Selecionados: ${schedule['selectedDays']}");
        log("------------------------------------------------");
      }
    } else {
      log("❌ Nenhuma agenda salva no cache.");
    }
  }
}
