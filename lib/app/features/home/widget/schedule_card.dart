import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widget/utils/images.dart';

class ScheduleCard extends StatelessWidget {
  final Map<String, dynamic> schedule;
  final VoidCallback onDelete;

  const ScheduleCard({
    super.key,
    required this.schedule,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      schedule['medicationName'] ?? 'Nome não informado',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onDelete,
                  child: SvgPicture.asset(
                    Images.binIcon,
                    colorFilter: ColorFilter.mode(
                        const Color.fromARGB(255, 214, 31, 18),
                        BlendMode.srcIn),
                    height: 20,
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SvgPicture.asset(
                  Images.calendarIcon,
                  height: 24,
                ),
                const SizedBox(width: 4),
                Text("Início: ${_formatDate(schedule['startDate'])}"),
                const SizedBox(width: 10),
                SvgPicture.asset(
                  Images.calendarIcon,
                  height: 24,
                ),
                const SizedBox(width: 4),
                Text("Término: ${_formatDate(schedule['endDate'])}"),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                SvgPicture.asset(
                  Images.hourIcon,
                  colorFilter: ColorFilter.mode(
                      const Color.fromARGB(255, 214, 31, 18), BlendMode.srcIn),
                  height: 24,
                ),
                const SizedBox(width: 8),
                Text("Horário: ${_formatTime(schedule['selectedTime'])}"),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: _buildWeekDays(schedule['selectedDays']),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(String? date) {
    if (date == null) return "Não definido";
    final parsedDate = DateTime.tryParse(date);
    if (parsedDate == null) return "Data inválida";

    final day = parsedDate.day.toString().padLeft(2, '0');
    final month = parsedDate.month.toString().padLeft(2, '0');
    final year = parsedDate.year;

    return "$day/$month/$year";
  }

  static String _formatTime(Map<String, dynamic>? time) {
    if (time == null) return "Não definido";
    return "${time['hour'].toString().padLeft(2, '0')}:${time['minute'].toString().padLeft(2, '0')}";
  }

  static List<Widget> _buildWeekDays(List<dynamic>? selectedDays) {
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

    return List.generate(weekDays.length, (i) {
      if (selectedDays[i]) {
        return Chip(
          label: Text(
            weekDays[i],
            style: GoogleFonts.lato(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue.shade100,
        );
      }
      return const SizedBox.shrink();
    }).where((widget) => widget is! SizedBox).toList();
  }
}
