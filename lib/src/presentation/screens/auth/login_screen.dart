import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_agence/src/core/theme/app_theme.dart';
import 'package:shop_agence/src/core/utils/validator_pass.dart';
import 'package:shop_agence/src/presentation/provider/theme_provider/theme_provider.dart';
import 'package:shop_agence/src/presentation/widgets/forms/custom_button.dart';
import 'package:shop_agence/src/presentation/widgets/forms/custom_text_form_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;
  //late final LoginUseCase _loginUseCase;
  // Instancia del DatabaseHelper

  @override
  void initState() {
    super.initState();
    //_loginUseCase = sl<LoginUseCase>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    print('Iniciando proceso de login...');

    // Aquí va tu lógica de login...

    setState(() => _isLoading = false);
  }

  String _parseErrorMessage(Object e) {
    final message = e.toString();

    if (message.contains('El usuario ya existe')) {
      return 'Este correo o nombre de usuario ya está registrado.';
    }

    if (message.contains('Credenciales incorrectas')) {
      return 'Correo o contraseña inválidos.';
    }

    // Mensaje genérico si no se reconoce el error
    return 'Ocurrió un error inesperado. Intenta nuevamente.';
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
          padding: const EdgeInsets.only(top: 40.0, left: 16, right: 16),
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
                  child: Image.asset(
                    'assets/shop_agence.png',
                    height: 180,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Center(
                    child: Text('Shop Agence', style: textStyles.textStyleTitle),
                  ),
                ),

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Iniciar Sesión | Bienvenido a Shop Agence',
                    style: textStyles.textStyleSubTitle,
                  ),
                ),

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomTextField(
                    controller: _emailController,
                    validationMessages: {
                      'required': (error) =>
                          'El campo usuario no puede estar vacío.',
                    },
                    label: Text(
                      'Usuario o correo electrónico',
                      style: textStyles.textStyleLabel,
                    ),
                    hintText: 'Ej: ana/admin@dominio.com',
                    prefixIcon: Icon(
                      Icons.person,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomObscureText(
                    controller: _passController,
                    validator: PasswordValidator.validatePassword,
                    label: Text('Contraseña', style: textStyles.textStyleLabel),
                    hintText: '****',
                    prefixIcon: Icon(
                      Icons.lock,
                      color: textStyles.textStyleTitle.color,
                    ),
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.visiblePassword,
                    maxLines: 1,
                    isPassword: true,
                    textType: TextInputType.text,
                  ),
                ),

                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: textStyles.textStyleSubTitle,
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.center,
                  child: _isLoading
                      ? CircularProgressIndicator(color: appTheme.pinkColor)
                      : CustomButton(
                          name: 'Iniciar sesión',
                          onTap: _handleLogin,
                          color: appTheme.textSecondaryColor,
                        ),
                ),

                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.pushReplacementNamed(context, 'register');
                          },
                    child: Text(
                      '¿No tienes cuenta? Regístrate',
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
