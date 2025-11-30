import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_agence/src/core/theme/app_theme.dart';
import 'package:shop_agence/src/core/theme/colors.dart';
import 'package:shop_agence/src/core/theme/dimensions.dart';

class AdaptiveTextStyles {
  final bool isDarkMode;

  AdaptiveTextStyles({required this.isDarkMode});

  // Método helper para obtener color adaptativo
  Color _adaptiveColor(Color lightColor) {
    return isDarkMode ? Colors.white : lightColor;
  }

  // Textos que mantienen su color en claro y son blancos en oscuro
  TextStyle get textStyleTitle => GoogleFonts.poppins(
    fontSize: 40,
    fontWeight: FontWeight.w900,
    color: _adaptiveColor(AppTheme.secondaryColor),
  );

  TextStyle get textStyleSubTitle => GoogleFonts.aBeeZee(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: _adaptiveColor(AppTheme.secondaryColor),
  );

  TextStyle get textStyleSubTitleBold => GoogleFonts.aBeeZee(
    fontSize: 50,
    fontWeight: FontWeight.w900,
    color: _adaptiveColor(AppTheme.secondaryColor),
  );

  TextStyle get textStyleCancelText => GoogleFonts.aBeeZee(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: _adaptiveColor(AppColors.red),
  );

  TextStyle get textStyleTextButton => GoogleFonts.aBeeZee(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: _adaptiveColor(AppColors.mediumGrey),
  );

  TextStyle get textStyleTitleDrawer => GoogleFonts.poppins(
    fontSize: 45,
    fontWeight: FontWeight.w800,
    color: _adaptiveColor(AppColors.platinum),
  );

  TextStyle get textStyleTextConten => GoogleFonts.aBeeZee(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: _adaptiveColor(AppColors.platinum),
  );

  TextStyle get textAppBar => GoogleFonts.aBeeZee(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: _adaptiveColor(AppColors.platinum),
  );

  TextStyle get textDrawer => GoogleFonts.aBeeZee(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: _adaptiveColor(AppColors.platinum),
  );

  // Textos que NO cambian (siempre el mismo color)
  TextStyle get textStyleAppBar => const TextStyle(
    fontSize: kBigFontSized,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.90,
  );

  TextStyle get textStyleDialogTitle => const TextStyle(
    fontSize: kBigFontSized,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.90,
  );

  TextStyle get textStyleLabel => const TextStyle(
    fontSize: kNormalFontSized,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.90,
  );

  TextStyle get textStyleBody => const TextStyle(
    fontSize: kNormalFontSized,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.90,
  );

  TextStyle get textStyleNavBar => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.90,
  );

  TextStyle get textStyleButton => const TextStyle(
    fontSize: kNormalFontSized,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.90,
  );
}
