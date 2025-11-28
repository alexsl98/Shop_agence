import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_agence/src/core/theme/app_theme.dart';
import 'package:shop_agence/src/core/utils/validator_pass.dart';
import 'package:shop_agence/src/presentation/provider/theme_provider/theme_provider.dart';
import 'package:shop_agence/src/presentation/widgets/forms/custom_button.dart';
import 'package:shop_agence/src/presentation/widgets/forms/custom_text_form_field.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _isLoading = false;
  //late final RegisterUseCase _registerUseCase;

  @override
  void initState() {
    super.initState();
    //_registerUseCase = sl<RegisterUseCase>();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // try {
    //   final username = _usernameController.text.trim().toLowerCase();
    //   final email = _emailController.text.trim();
    //   final password = _passController.text.trim();

    //   final success = await _registerUseCase.call(
    //     username: username,
    //     email: email,
    //     password: password,
    //   );

    //   if (success && mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('¡Usuario registrado exitosamente!'),
    //         backgroundColor: Colors.green,
    //         duration: Duration(seconds: 2),
    //       ),
    //     );

    //     await Future.delayed(const Duration(seconds: 1));
    //     Navigator.pushReplacementNamed(context, 'login');
    //   }
    // } catch (e) {
    //   String errorMessage = 'Error en el registro';

    //   final error = e.toString();

    //   if (error.contains('EMAIL_EXISTS')) {
    //     errorMessage = 'Este correo electrónico ya está registrado';
    //   } else if (error.contains('USERNAME_EXISTS')) {
    //     errorMessage = 'El nombre de usuario ya está en uso';
    //   } else if (error.contains('REGISTER_ERROR')) {
    //     errorMessage = 'Ocurrió un error inesperado. Intenta nuevamente.';
    //   }

    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(errorMessage),
    //         backgroundColor: Colors.red,
    //         duration: const Duration(seconds: 3),
    //       ),
    //     );
    //   }
    // } finally {
    //   if (mounted) {
    //     setState(() => _isLoading = false);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final appTheme = AppTheme(isDarkmode: isDarkMode);
    final textStyles = appTheme.textStyles;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Toggle de tema
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
                  child: Image.asset('assets/shop_agence.png', height: 180),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Center(
                    child: Text('Shop Agence', style: textStyles.textStyleTitle),
                  ),
                ),

                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Registro | Bienvenido a Shop Agence',
                    style: textStyles.textStyleSubTitle,
                  ),
                ),

                const SizedBox(height: 20),

                // Usuario
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomTextField(
                    controller: _usernameController,
                    isUsername: true,
                    validationMessages: {
                      'required': (_) =>
                          'El campo usuario no puede estar vacío.',
                      'invalidUsername': (_) => 'Ingrese un usuario válido.',
                    },
                    label: Text('Usuario', style: textStyles.textStyleLabel),
                    hintText: 'Ej: ana88',
                    prefixIcon: Icon(
                      Icons.person,
                      color: textStyles.textStyleTitle.color,
                    ),
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    textType: TextInputType.text,
                  ),
                ),

                const SizedBox(height: 16),

                // Email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomTextField(
                    controller: _emailController,
                    isEmail: true,
                    validationMessages: {
                      'required': (_) =>
                          'El campo correo no puede estar vacío.',
                      'invalidEmail': (_) => 'Ingrese un correo válido.',
                    },
                    label: Text(
                      'Correo electrónico',
                      style: textStyles.textStyleLabel,
                    ),
                    hintText: 'Ej: admin@dominio.com',
                    prefixIcon: Icon(
                      Icons.email,
                      color: textStyles.textStyleTitle.color,
                    ),
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    textType: TextInputType.text,
                  ),
                ),

                const SizedBox(height: 16),

                // Contraseña
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomObscureText(
                    controller: _passController,
                    isPassword: true,
                    validator: PasswordValidator.validatePassword,
                    label: Text('Contraseña', style: textStyles.textStyleLabel),
                    hintText: '****',
                    prefixIcon: Icon(
                      Icons.lock,
                      color: textStyles.textStyleTitle.color,
                    ),
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.visiblePassword,
                    maxLines: 1,
                    textType: TextInputType.text,
                  ),
                ),

                const SizedBox(height: 16),

                // Confirmación
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomObscureText(
                    controller: _confirmPassController,
                    isConfirmPassword: true,
                    passwordToMatchController: _passController,
                    validator: (value) =>
                        PasswordValidator.validateConfirmPassword(
                          value,
                          _passController.text,
                        ),
                    label: Text(
                      'Confirmar contraseña',
                      style: textStyles.textStyleLabel,
                    ),
                    hintText: '****',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: textStyles.textStyleTitle.color,
                    ),
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.visiblePassword,
                    maxLines: 1,
                    textType: TextInputType.text,
                  ),
                ),

                const SizedBox(height: 24),

                // Botón
                Align(
                  alignment: Alignment.center,
                  child: _isLoading
                      ? CircularProgressIndicator(color: appTheme.pinkColor)
                      : CustomButton(
                          name: 'Registrarse',
                          onTap: _handleRegister,
                          color: appTheme.pinkColor,
                        ),
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.pushNamed(context, 'login');
                          },
                    child: Text(
                      '¿Ya tienes cuenta? Inicia sesión',
                      style: textStyles.textStyleSubTitle.copyWith(
                        color: _isLoading
                            ? Colors.grey
                            : textStyles.textStyleSubTitle.color,
                      ),
                    ),
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
