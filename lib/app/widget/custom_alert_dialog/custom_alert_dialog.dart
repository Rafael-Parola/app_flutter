import 'dart:async';
import 'dart:developer';
import 'package:app_flutter/app/widget/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAlertDialog extends StatefulWidget {
  final String? title;
  final String? message;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final int duration;
  final VoidCallback? onDismiss;

  const CustomAlertDialog({
    super.key,
    this.title,
    this.message,
    this.backgroundColor = CustomColors.blue,
    this.textColor = CustomColors.white,
    this.width = 300.0,
    this.duration = 3,
    this.onDismiss,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  bool _isDialogVisible = false;
  double _dialogPosition = -1.0;
  late Timer _timer;
  int _timeLeft = 0;

  @override
  void initState() {
    super.initState();
    _showDialog();
  }

  void _showDialog() {
    setState(() {
      _isDialogVisible = true;
      _dialogPosition = -widget.width;
    });

    log("Timer iniciado com duração de ${widget.duration} segundos");

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft < widget.duration) {
          _timeLeft++;
          log("Tempo restante: $_timeLeft segundos");
        } else {
          _dialogPosition = -widget.width;
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              _isDialogVisible = false;
            });
            widget.onDismiss?.call();
          });
          _timer.cancel();
        }
      });
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _dialogPosition = 0.0;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isDialogVisible)
          GestureDetector(
            onTap: () {
              setState(() {
                _dialogPosition = -widget.width;
              });
              Future.delayed(const Duration(milliseconds: 500), () {
                setState(() {
                  _isDialogVisible = false;
                });
                widget.onDismiss?.call();
              });
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          right: _dialogPosition,
          top: 80.0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: widget.width,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: widget.backgroundColor.withOpacity(0.8),
                border: Border.all(color: widget.backgroundColor, width: 2.0),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.title != null)
                    Text(
                      widget.title!,
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (widget.title != null) const SizedBox(height: 10),
                  if (widget.message != null)
                    Text(
                      widget.message!,
                      style: GoogleFonts.workSans(
                          color: widget.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
