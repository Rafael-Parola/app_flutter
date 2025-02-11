import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double width;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double fontSize;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.width,
    required this.backgroundColor,
    required this.textColor,
    required this.borderRadius,
    required this.fontSize,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: fontSize),
        ),
      ),
    );
  }
}
