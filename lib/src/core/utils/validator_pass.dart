import 'package:shop_agence/src/core/utils/regex_validation.dart';

class PasswordValidator {
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'El campo contraseña no puede estar vacío.';
    }

    // Verificar espacios al inicio o final
    if (value.trim() != value) {
      return 'La contraseña no puede contener espacios al inicio o final.';
    }

    // Verificar longitud mínima
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres.';
    }

    // Verificar mayúscula
    if (!RegExp(RegExpUtil.passwordHasUpperCase).hasMatch(value)) {
      return 'La contraseña debe contener al menos una letra mayúscula.';
    }

    // Verificar minúscula
    if (!RegExp(RegExpUtil.passwordHasLowerCase).hasMatch(value)) {
      return 'La contraseña debe contener al menos una letra minúscula.';
    }

    // Verificar número
    if (!RegExp(RegExpUtil.passwordHasNumber).hasMatch(value)) {
      return 'La contraseña debe contener al menos un número.';
    }

    // Verificar carácter especial
    if (!RegExp(RegExpUtil.passwordHasSpecialChar).hasMatch(value)) {
      return 'La contraseña debe incluir al menos un carácter especial (!@#\$%&*).';
    }

    return null; // Contraseña válida
  }

  static String? validateConfirmPassword(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'El campo confirmar contraseña no puede estar vacío.';
    }

    if (!RegExpUtil.confirmPasswordMatch(originalPassword, value)) {
      return 'Las contraseñas no coinciden.';
    }

    return null;
  }
}
