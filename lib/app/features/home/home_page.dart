import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widget/colors/colors.dart';
import '../../widget/cutom_app_bar/custom_app_bar.dart';
import '../add_calendar/add_calendar.dart';
import '../settings/settings_page.dart';
import 'controller/home_page_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final HomePageController homeController = HomePageController();
  List<Map<String, dynamic>> schedules = [];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    final loadedSchedules = await homeController.loadSchedules();
    setState(() {
      schedules = loadedSchedules;
    });
  }

  Future<void> _deleteSchedule(int id) async {
    await homeController.deleteSchedule(schedules, id);
    _loadSchedules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        title: 'Agenda de Medicamentos',
        centerTitle: true,
        trailingIcon: Icons.settings,
        onPressedTrailing: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
        },
      ),
      body: schedules.isEmpty
          ? const Center(child: Text('Nenhuma agenda salva'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Agenda #${schedule['id']}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                            "🗓 Início: ${_formatDate(schedule['startDate'])}"),
                        Text("🗓 Término: ${_formatDate(schedule['endDate'])}"),
                        Text(
                            "⏰ Horário: ${_formatTime(schedule['selectedTime'])}"),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          children: _buildWeekDays(schedule['selectedDays']),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteSchedule(schedule['id']),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCalendarPage()),
          );
          _loadSchedules();
        },
        backgroundColor: CustomColors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null) return "Não definido";
    return DateTime.tryParse(date) != null
        ? "${DateTime.parse(date).day}/${DateTime.parse(date).month}/${DateTime.parse(date).year}"
        : "Data inválida";
  }

  String _formatTime(Map<String, dynamic>? time) {
    if (time == null) return "Não definido";
    return "${time['hour'].toString().padLeft(2, '0')}:${time['minute'].toString().padLeft(2, '0')}";
  }

  List<Widget> _buildWeekDays(List<dynamic>? selectedDays) {
    final List<String> weekDays = [
      "Dom",
      "Seg",
      "Ter",
      "Qua",
      "Qui",
      "Sex",
      "Sáb"
    ];
    if (selectedDays == null) return [];

    List<Widget> chips = [];
    for (int i = 0; i < weekDays.length; i++) {
      if (selectedDays[i]) {
        chips.add(
          Chip(
            label: Text(
              weekDays[i],
              style: GoogleFonts.lato(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.blue.shade100,
          ),
        );
      }
    }
    return chips;
  }
}
