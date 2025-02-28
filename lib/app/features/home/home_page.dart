import 'package:flutter/material.dart';
import '../../widget/colors/colors.dart';
import '../../widget/cutom_app_bar/custom_app_bar.dart';
import '../add_calendar/add_calendar.dart';
import '../settings/settings_page.dart';
import 'controller/home_page_controller.dart';
import 'widget/schedule_card.dart';

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
                return ScheduleCard(
                  schedule: schedule,
                  onDelete: () => _deleteSchedule(schedule['id']),
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
}
