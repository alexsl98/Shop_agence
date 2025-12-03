import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop_agence/src/core/theme/app_theme.dart';
import 'package:shop_agence/src/core/utils/validator_pass.dart';
import 'package:shop_agence/src/data/data_source/services/auth_services.dart';
import 'package:shop_agence/src/data/models/user_model.dart';
import 'package:shop_agence/src/presentation/provider/theme_provider/theme_provider.dart';
import 'package:shop_agence/src/presentation/screens/auth/login_screen.dart';
import 'package:shop_agence/src/presentation/widgets/forms/custom_button.dart';
import 'package:shop_agence/src/presentation/widgets/forms/custom_text_form_field.dart';
import 'package:shop_agence/src/presentation/widgets/snack_bar.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      UserModel newUser = UserModel(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        address: _addressController.text.trim(),
        name: _nameController.text.trim(),
      );

      await AuthMethod().signupUser(newUser);

      setState(() {
        _isLoading = false;
      });

      showSnackBar(
        context,
        '¡Usuario registrado exitosamente!',
        type: SnackBarType.success,
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } on Exception catch (e) {
      setState(() {
        _isLoading = false;
      });

      showSnackBar(context, e.toString(), type: SnackBarType.error);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      showSnackBar(
        context,
        'Ocurrió un error inesperado. Revise su conexión e intente nuevamente.',
        type: SnackBarType.error,
      );
    }
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
                    controller: _nameController,
                    isUsername: true,
                    validationMessages: {
                      'required': (_) =>
                          'El campo nombre no puede estar vacío.',
                      'invalidname': (_) => 'Ingrese un nombre válido.',
                    },
                    label: Text('Nombre', style: textStyles.textStyleLabel),
                    hintText: 'Ej: Ana',
                    prefixIcon: Icon(
                      Iconsax.user,
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
                      Iconsax.sms,
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
                    controller: _passwordController,
                    isPassword: true,
                    validator: PasswordValidator.validatePassword,
                    label: Text('Contraseña', style: textStyles.textStyleLabel),
                    hintText: '****',
                    prefixIcon: Icon(
                      Iconsax.lock,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomTextField(
                    controller: _addressController,
                    validationMessages: {
                      'required': (_) =>
                          'El campo dirección no puede estar vacío.',
                    },
                    label: Text('Dirección', style: textStyles.textStyleLabel),
                    hintText: 'Ej: Ana',
                    prefixIcon: Icon(
                      Iconsax.location,
                      color: textStyles.textStyleTitle.color,
                    ),
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.text,
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
                          color: AppTheme.secondaryColor,
                        ),
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.pushNamed(context, '/');
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
