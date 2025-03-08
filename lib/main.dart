import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'app/features/initial_page/controller/register_controller.dart';
import 'app/features/splash_page/splash_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  //await requestExactAlarmPermission();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterController()),
      ],
      child: const MedicineSchedule(),
    ),
  );
}

Future<void> requestExactAlarmPermission() async {
  final status = await Permission.notification.status;

  if (status.isDenied || status.isPermanentlyDenied) {
    await openAppSettings();
  } else if (status.isGranted) {
    log("Permissão SET_EXACT_ALARM já concedida.");
  } else {
    final result = await Permission.notification.request();
    if (result.isGranted) {
      log("Permissão SET_EXACT_ALARM concedida.");
    } else {
      log("Permissão SET_EXACT_ALARM negada.");
    }
  }
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
      home: const SplashScreen(),
    );
  }
}
