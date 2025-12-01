import 'package:flutter/material.dart';

enum SnackBarType { success, error, warning, info }

void showSnackBar(
  BuildContext context,
  String text, {
  SnackBarType type = SnackBarType.info,
  Duration? duration,
  SnackBarAction? action,
}) {
  // Definir colores según el tipo
  Color backgroundColor;
  Color textColor;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = Colors.green;
      textColor = Colors.white;
      break;
    case SnackBarType.error:
      backgroundColor = Colors.red;
      textColor = Colors.white;
      break;
    case SnackBarType.warning:
      backgroundColor = Colors.orange;
      textColor = Colors.black;
      break;
    case SnackBarType.info:
    default:
      backgroundColor = Colors.blue;
      textColor = Colors.white;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text, style: TextStyle(color: textColor)),
      backgroundColor: backgroundColor,
      duration: duration ?? const Duration(seconds: 2),
      action: action,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
