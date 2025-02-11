import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/features/initial_page/controller/register_controller.dart';
import 'app/features/splash_page/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterController()),
      ],
      child: MedicineSchedule(),
    ),
  );
}

class MedicineSchedule extends StatelessWidget {
  const MedicineSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda de medicamentos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  SplashScreen(), 
    );
  }
}
