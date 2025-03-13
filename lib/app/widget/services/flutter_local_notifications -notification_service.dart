import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    await checkNotificationPermissions();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(settings);

    final details =
        await _notificationsPlugin.getNotificationAppLaunchDetails();
    if (details?.notificationResponse != null) {
      onSelectNotification(details!.notificationResponse!.payload);
    }

    await createNotificationChannel();
  }

  static Future<void> checkNotificationPermissions() async {
    if (await Permission.notification.isGranted) {
      log("Permissões de notificação já concedidas.");
    } else {
      PermissionStatus status = await Permission.notification.request();
      if (status.isGranted) {
        log("Permissões de notificação concedidas.");
      } else {
        log("Permissões de notificação negadas.");
      }
    }
  }

  static Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'medication_channel',
      'Lembretes de Medicamentos',
      description: 'Canal para notificações de lembretes de medicamentos',
      importance: Importance.high,
      playSound: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    try {
      DateTime now = DateTime.now();
      log("Hora atual: $now");

      final localScheduledDate = tz.TZDateTime.local(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        scheduledDate.hour,
        scheduledDate.minute,
      );
      log("Hora agendada: $localScheduledDate");
      if (localScheduledDate.isBefore(now)) {
        final adjustedDate = localScheduledDate.add(const Duration(days: 1));
        log("Hora ajustada (se a hora agendada foi no passado): $adjustedDate");
        await _notificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          adjustedDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'medication_channel',
              'Lembretes de Medicamentos',
              importance: Importance.high,
              priority: Priority.high,
              playSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exact,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } else {
        await _notificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          localScheduledDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'medication_channel',
              'Lembretes de Medicamentos',
              importance: Importance.high,
              priority: Priority.high,
              playSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exact,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    } catch (e) {
      log("Erro ao agendar notificação: $e");
    }
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  static Future onSelectNotification(String? payload) async {
    if (payload != null) {
      log('Notificação selecionada com o payload: $payload');
    }
  }
}
