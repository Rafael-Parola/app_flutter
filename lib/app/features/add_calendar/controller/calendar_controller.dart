import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import '../../../widget/services/notification_service.dart';

class AddCalendarController extends ChangeNotifier {
  List<bool> selectedDays = List.generate(7, (index) => false);
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? selectedTime;
  String medicationName = ""; // Nome do medicamento

  final List<String> weekDays = [
    "Dom",
    "Seg",
    "Ter",
    "Qua",
    "Qui",
    "Sex",
    "Sáb"
  ];

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  void setMedicationName(String name) {
    medicationName = name;
    notifyListeners();
  }

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
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      helpText: 'Selecionar horário',
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
        : "${date.day}/${date.month}/${date.year}";
  }

  String getFormattedTime(BuildContext context) {
    return selectedTime == null
        ? "Selecionar horário"
        : selectedTime!.format(context);
  }

  Future<void> saveSchedule(BuildContext context) async {
    try {
      final String? storedData =
          await _storage.read(key: "medication_schedules");
      List<Map<String, dynamic>> schedules = storedData != null
          ? List<Map<String, dynamic>>.from(jsonDecode(storedData))
          : [];

      final newSchedule = {
        "id": schedules.length + 1,
        "medicationName": medicationName,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "selectedTime": selectedTime != null
            ? {"hour": selectedTime!.hour, "minute": selectedTime!.minute}
            : null,
        "selectedDays": selectedDays,
      };

      // Verifica os dias selecionados e agenda a notificação para cada um
      for (int i = 0; i < selectedDays.length; i++) {
        if (selectedDays[i]) {
          // Calcula a data para o dia selecionado
          DateTime notificationDate = startDate ?? DateTime.now();

          // Ajusta a data para o próximo dia correspondente
          while (notificationDate.weekday != i + 1) {
            notificationDate = notificationDate.add(Duration(days: 1));
          }

          // Ajusta a data para o horário selecionado
          if (selectedTime != null) {
            notificationDate = DateTime(
              notificationDate.year,
              notificationDate.month,
              notificationDate.day,
              selectedTime!.hour,
              selectedTime!.minute,
            );
          }

          /*   // Agendar a notificação para cada dia selecionado
          await NotificationService.scheduleNotification(
            id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // ID único
            title: "Hora do medicamento",
            body: "Está na hora de tomar $medicationName!",
            scheduledDate: notificationDate,
          ); */
        }
      }

      // Salva o agendamento no armazenamento seguro
      schedules.add(newSchedule);
      await _storage.write(
          key: "medication_schedules", value: jsonEncode(schedules));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Agenda salva com sucesso!")),
      );

      await logSavedSchedules();
      Navigator.pop(context);
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
        log("🔹 Medicamento: ${schedule['medicationName']}");
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
