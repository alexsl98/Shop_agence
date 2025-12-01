import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop_agence/src/core/theme/app_theme.dart';
import 'package:shop_agence/src/core/theme/text_styles.dart' as textStyles;
import 'package:shop_agence/src/presentation/provider/theme_provider/theme_provider.dart';
import 'package:shop_agence/src/presentation/widgets/forms/custom_button.dart';
import 'package:shop_agence/src/presentation/widgets/forms/custom_text_form_field.dart';
import 'package:shop_agence/src/presentation/widgets/snack_bar.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      AlertDialog(
        title: const Text('Correo enviado'),
        content: const Text(
          'Se ha enviado un correo electrónico para restablecer tu contraseña. Revisa tu bandeja de entrada.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      String errorMessage = 'Error al enviar el correo de recuperación';

      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'user-not-found':
            errorMessage = 'No existe una cuenta con este correo electrónico';
            break;
          case 'invalid-email':
            errorMessage = 'El formato del correo electrónico es inválido';
            break;
          case 'network-request-failed':
            errorMessage = 'Error de conexión. Verifica tu internet';
            break;
          default:
            errorMessage = error.message ?? 'Error desconocido';
        }
      }

      showSnackBar(context, errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final appTheme = AppTheme(isDarkmode: isDarkMode);
    return Scaffold(
      backgroundColor: appTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 40.0,
            left: 16,
            right: 16,
            bottom: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: textStyles.textStyleSubTitle.color,
                      ),
                      onPressed: () {
                        ref.read(themeProvider.notifier).toggleTheme();
                      },
                    ),
                  ],
                ),

                Center(
                  child: Image.asset('assets/agence_shop.png', height: 180),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    '¿Olvidaste tu contraseña? | Shop Agence',
                    style: textStyles.textStyleSubTitle,
                  ),
                ),

                const SizedBox(height: 20),

                // Email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomTextField(
                    controller: _emailController,
                    validationMessages: {
                      'required': (error) =>
                          'El campo correo no puede estar vacío.',
                    },
                    label: Text(
                      'Correo electrónico',
                      style: textStyles.textStyleLabel,
                    ),
                    hintText: 'Ej: ana/admin@dominio.com',
                    prefixIcon: Icon(
                      Iconsax.sms,
                      color: textStyles.textStyleTitle.color,
                    ),
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    isEmail: false,
                    textType: TextInputType.text,
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: _isLoading
                      ? CircularProgressIndicator(color: appTheme.pinkColor)
                      : CustomButton(
                          name: 'Iniciar sesión',
                          onTap: _handResetPassword,
                          color: AppTheme.secondaryColor,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
