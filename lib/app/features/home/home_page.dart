import 'package:flutter/material.dart';
import '../../widget/colors/colors.dart';
import '../../widget/cutom_app_bar/custom_app_bar.dart';
import '../add_calendar/add_calendar.dart';
import '../settings/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        title: 'Agenda de medicamentos',
        centerTitle: true,
        trailingIcon: Icons.settings,
        onPressedTrailing: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
        },
      ),
      body: Center(child: Text('Conteúdo da página inicial')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddCalendarPage()),
          );
        },
        backgroundColor: CustomColors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}
