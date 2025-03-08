import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Inicializa o serviço de notificações
  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(settings);

    await createNotificationChannel();
  }

  // Cria o canal de notificação
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

  // Agenda a notificação
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    try {
      // Converte a data para a zona horária local
      final localScheduledDate = tz.TZDateTime.local(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        scheduledDate.hour,
        scheduledDate.minute,
      );

      final currentTime = tz.TZDateTime.now(tz.local);

      // Se a hora já passou, agenda para o próximo dia
      if (localScheduledDate.isBefore(currentTime)) {
        log("A hora agendada já passou para hoje. Agendando para o próximo dia.");
        final adjustedDate = localScheduledDate.add(const Duration(days: 1));
        log("Nova data ajustada: $adjustedDate");

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
              playSound: true, // Certifique-se de que o som será tocado
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.inexact,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } else {
        log("Agendando para o mesmo dia, horário futuro.");
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
              playSound: true, // Certifique-se de que o som será tocado
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.inexact,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }

      log("Notificação agendada com sucesso para: $localScheduledDate");
    } catch (e) {
      log("Erro ao agendar notificação: $e");
    }
  }

  // Cancela a notificação
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}
