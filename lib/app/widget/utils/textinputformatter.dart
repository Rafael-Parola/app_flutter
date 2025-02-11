import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.length > oldValue.text.length) {
      if (text.length == 2 || text.length == 5) {
        return TextEditingValue(
          text: '$text/',
          selection: TextSelection.fromPosition(
            TextPosition(offset: text.length + 1),
          ),
        );
      }
    }
    return newValue;
  }
}
