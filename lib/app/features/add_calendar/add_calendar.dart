import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../widget/cutom_app_bar/custom_app_bar.dart';
import 'controller/calendar_controller.dart';

class AddCalendarPage extends StatefulWidget {
  const AddCalendarPage({super.key});

  @override
  State<AddCalendarPage> createState() => _AddCalendarPageState();
}

class _AddCalendarPageState extends State<AddCalendarPage> {
  late AddCalendarController _controller;
  final TextEditingController _medicationController = TextEditingController();
  bool _isDateEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller = AddCalendarController();
  }

  @override
  void dispose() {
    _medicationController.dispose();
    super.dispose();
  }

  Future<void> _requestNotificationPermission() async {
    PermissionStatus notification = await Permission.notification.request();
    PermissionStatus alarm = await Permission.scheduleExactAlarm.request();
    //scheduledAlarms
    if (notification.isGranted && alarm.isGranted) {
      log("Permissão de notificação concedida.");
    } else {
      log("Permissão de notificação não concedida.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _controller,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Criar agenda',
          centerTitle: true,
          leadingIcon: Icons.arrow_back_rounded,
          onPressedleading: () => Navigator.pop(context),
        ),
        body: Consumer<AddCalendarController>(
          builder: (context, controller, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Nome do medicamento:",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _medicationController,
                    decoration: InputDecoration(
                      hintText: "Digite o nome do medicamento",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Data de início:",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    ElevatedButton(
                                      onPressed: _isDateEnabled
                                          ? () => controller.selectDate(
                                              context, true)
                                          : null,
                                      child: Text(controller.getFormattedDate(
                                          controller.startDate)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Data de término:",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    ElevatedButton(
                                      onPressed: _isDateEnabled
                                          ? () => controller.selectDate(
                                              context, false)
                                          : null,
                                      child: Text(controller.getFormattedDate(
                                          controller.endDate)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -15,
                          right: 70,
                          child: Row(
                            children: [
                              Checkbox(
                                value: _isDateEnabled,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isDateEnabled = value ?? false;
                                  });
                                },
                              ),
                              const Text('Definir data de início e fim'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: const Text(
                      "Dias da semana:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Wrap(
                      spacing: 5.0,
                      children:
                          List.generate(controller.weekDays.length, (index) {
                        return FilterChip(
                          label: Text(controller.weekDays[index]),
                          selected: controller.selectedDays[index],
                          selectedColor: Colors.green.shade400,
                          backgroundColor: Colors.white,
                          onSelected: (selected) {
                            controller.toggleDay(index);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          showCheckmark: false,
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: const Text(
                      "Horário do medicamento:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => controller.selectTime(context),
                      child: Text(controller.getFormattedTime(context)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding:
              const EdgeInsets.only(bottom: 30, left: 20, right: 20, top: 1),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                await _requestNotificationPermission();
                _controller.setMedicationName(_medicationController.text);
                _controller.saveSchedule(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Salvar Agenda"),
            ),
          ),
        ),
      ),
    );
  }
}
