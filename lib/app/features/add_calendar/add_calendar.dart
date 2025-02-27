import 'package:flutter/material.dart';
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
                  Text(
                    "Nome do medicamento:",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
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
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Data de início:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  controller.selectDate(context, true),
                              child: Text(controller
                                  .getFormattedDate(controller.startDate)),
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
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  controller.selectDate(context, false),
                              child: Text(controller
                                  .getFormattedDate(controller.endDate)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Dias da semana:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children:
                        List.generate(controller.weekDays.length, (index) {
                      return FilterChip(
                        label: Text(controller.weekDays[index]),
                        selected: controller.selectedDays[index],
                        onSelected: (selected) => controller.toggleDay(index),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Horário do medicamento:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () => controller.selectTime(context),
                    child: Text(controller.getFormattedTime(context)),
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
              onPressed: () {
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
