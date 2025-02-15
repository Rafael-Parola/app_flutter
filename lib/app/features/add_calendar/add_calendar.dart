import 'package:flutter/material.dart';
import 'package:app_flutter/app/features/home/home_page.dart';
import '../../widget/cutom_app_bar/custom_app_bar.dart';

class AddCalendarPage extends StatefulWidget {
  const AddCalendarPage({super.key});

  @override
  AddCalendarPageState createState() => AddCalendarPageState();
}

class AddCalendarPageState extends State<AddCalendarPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        title: 'Criar agenda',
        centerTitle: true,
        leadingIcon: Icons.arrow_back_rounded,
        onPressedleading: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
      ),
      body: Center(child: Text('Conteúdo da página adição de agenda')),
    );
  }
}
