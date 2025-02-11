import 'package:flutter/widgets.dart';

class Resizer {
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double relativeWidth(BuildContext context, double percentage) =>
      screenWidth(context) * (percentage / 100);

  static double relativeHeight(BuildContext context, double percentage) =>
      screenHeight(context) * (percentage / 100);

  static double relativeFontSize(BuildContext context, double percentage) =>
      relativeWidth(context, percentage);
}
