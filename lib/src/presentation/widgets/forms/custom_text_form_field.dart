import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop_agence/src/core/theme/app_theme.dart';
import 'package:shop_agence/src/core/theme/colors.dart';
import 'package:shop_agence/src/core/theme/text_styles.dart' as textStyles;
import 'package:shop_agence/src/core/utils/regex_validation.dart';

class CustomTextField extends StatelessWidget {
  final Widget? label;
  final String? hintText;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final TextInputType textType;
  final TextInputAction? textInputAction;
  final Map<String, String Function(Object)>? validationMessages;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;

  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool isEmailOrUsername;
  final bool isUsername;
  final bool isEmail;
  final bool isPassword;
  final Color? textColor;
  final Color? hintColor;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? labelColor;
  final Color? prefixIconColor;

  const CustomTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.prefixIcon,
    required this.textType,
    this.textInputAction,
    this.inputFormatters,
    required this.textCapitalization,
    this.keyboardType,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.validationMessages,
    this.isEmailOrUsername = false,
    this.isPassword = false,
    this.isEmail = false,
    this.isUsername = false,
    this.textColor,
    this.hintColor,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.labelColor,
    this.prefixIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: textColor ?? Colors.black),
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType ?? textType,
      textInputAction: textInputAction,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessages?['required']?.call(value ?? '') ??
              'Este campo es obligatorio';
        }
        if (isEmailOrUsername &&
            !RegExp(RegExpUtil.emailOrUsernameRegExp).hasMatch(value)) {
          return validationMessages?['invalidEmailOrUser']?.call(value) ??
              'Por favor, ingrese un correo o usuario válido.';
        }

        if (isUsername && !RegExp(RegExpUtil.usernameRegExp).hasMatch(value)) {
          return validationMessages?['invalidname']?.call(value) ??
              'Nombre de nombre inválido. Usa letras, números, puntos o guiones bajos. Debe comenzar con una letra.';
        }

        if (isEmail && !RegExp(RegExpUtil.emailRegExp).hasMatch(value)) {
          return validationMessages?['invalidEmail']?.call(value) ??
              'Por favor, ingrese un correo electrónico válido.';
        }

        return null;
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor ?? Colors.black),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: focusedBorderColor ?? AppColors.blueForDarkMode,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: errorBorderColor ?? Colors.red),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: errorBorderColor ?? Colors.red,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: prefixIcon != null && prefixIconColor != null
            ? IconTheme(
                data: IconThemeData(color: prefixIconColor!),
                child: prefixIcon!,
              )
            : prefixIcon,
        label: label,
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor ?? Colors.grey[600]),
        labelStyle: TextStyle(color: labelColor ?? textColor ?? Colors.black),
        fillColor: fillColor ?? Colors.white,
        filled: true,
        errorMaxLines: 3,
        errorStyle: const TextStyle(color: Colors.red),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}

// CustomObscureText
class CustomObscureText extends StatefulWidget {
  final String? hintText;
  final Widget? label;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final TextInputType textType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;

  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool isPassword;
  final bool isConfirmPassword;
  final TextEditingController? passwordToMatchController;
  final Color? textColor;
  final Color? hintColor;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? suffixIconColor;
  final Color? labelColor;
  final Color? prefixIconColor;

  const CustomObscureText({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.prefixIcon,
    required this.textType,
    this.textInputAction,
    this.validator,
    this.inputFormatters,
    required this.textCapitalization,
    this.keyboardType,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.isPassword = false,
    this.isConfirmPassword = false,
    this.passwordToMatchController,
    this.textColor,
    this.hintColor,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.suffixIconColor,
    this.labelColor,
    this.prefixIconColor,
  });

  @override
  State<CustomObscureText> createState() => _CustomObscureTextState();
}

class _CustomObscureTextState extends State<CustomObscureText> {
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    // Escucha cambios en la contraseña original si es confirmación
    if (widget.isConfirmPassword && widget.passwordToMatchController != null) {
      widget.passwordToMatchController!.addListener(() {
        setState(() {});
      });
    }
  }

  void _toggleObscureText() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: TextStyle(color: widget.textColor ?? Colors.black),
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType ?? widget.textType,
      textInputAction: widget.textInputAction,
      maxLength: widget.maxLength,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      obscureText: _isObscured,
      validator: widget.validator,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.borderColor ?? Colors.black),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.focusedBorderColor ?? AppColors.blueForDarkMode,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.errorBorderColor ?? Colors.red),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.errorBorderColor ?? Colors.red,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: widget.hintText,
        label: widget.label,
        hintStyle: TextStyle(color: widget.hintColor ?? Colors.grey[600]),
        labelStyle: TextStyle(
          color: widget.labelColor ?? widget.textColor ?? Colors.black,
        ),
        prefixIcon: widget.prefixIcon != null && widget.prefixIconColor != null
            ? IconTheme(
                data: IconThemeData(color: widget.prefixIconColor!),
                child: widget.prefixIcon!,
              )
            : widget.prefixIcon,
        fillColor: widget.fillColor ?? Colors.white,
        filled: true,
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Iconsax.eye_slash : Iconsax.eye,
            color: widget.suffixIconColor ?? AppTheme.secondaryColor,
          ),
          onPressed: _toggleObscureText,
        ),
        errorMaxLines: 3,
        errorStyle: const TextStyle(color: Colors.red),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
