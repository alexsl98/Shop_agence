import 'package:flutter/material.dart';

abstract class AppColors {
  static const blue = Color(0xFF0059D6);
  static const blueForDarkMode = Color(0xFF5087E6);
  static const blueTitle = Color(0xFF2F1BB0);
  static const red = Color(0xffB11C1C);
  static const platinum = Color(0xfff6f6f6);
  static const pink = Color(0xFFFF6F61);
  static const pinkclaro = Color(0xFFFF8B78);
  static const pinkdark = Color(0xFFCC554D);
  static const lightGrey = Color(0xffe5e5e7);
  static const mediumGrey = Color(0xff808084);
  static const black = Color.fromARGB(255, 25, 25, 27);
}

Color getPrimaryColorByTheming(
  BuildContext context, {
  Color? lightColor,
  Color? darkColor,
}) {
  if (Theme.of(context).brightness == Brightness.light) {
    return lightColor ?? Theme.of(context).primaryColor;
  } else {
    return darkColor ?? Colors.white;
  }
}
