import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop_agence/src/core/theme/app_theme.dart';
import 'package:shop_agence/src/core/utils/validator_pass.dart';
import 'package:shop_agence/src/data/data_source/services/auth_services.dart';
import 'package:shop_agence/src/data/data_source/services/facebook_auth_services.dart';
import 'package:shop_agence/src/data/data_source/services/google_auth_services.dart';
import 'package:shop_agence/src/presentation/provider/theme_provider/theme_provider.dart';
import 'package:shop_agence/src/presentation/screens/home_screen.dart';
import 'package:shop_agence/src/presentation/widgets/forms/custom_button.dart';
import 'package:shop_agence/src/presentation/widgets/forms/custom_text_form_field.dart';
import 'package:shop_agence/src/presentation/widgets/snack_bar.dart';

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
  bool _isGoogleLoading = false;
  bool _isFacebookLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethod().loginUser(
      email: _emailController.text,
      password: _passController.text,
    );

    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, res, type: SnackBarType.error);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      final user = await GoogleAuthServices().signInWithGoogle();

      if (user != null) {
        setState(() {
          _isGoogleLoading = false;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );

        showSnackBar(
          context,
          '¡Bienvenido ${user.displayName ?? user.email}!',
          type: SnackBarType.success,
        );
      } else {
        setState(() {
          _isGoogleLoading = false;
        });
        print('Flujo cancelado por el usuario');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isGoogleLoading = false;
      });
      showSnackBar(
        context,
        'Ocurrio un error inesperado. Revise su conexión e intente nuevamente.',
        type: SnackBarType.error,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(
        context,
        'Error al iniciar sesión con Google',
        type: SnackBarType.error,
      );
    }
  }

  Future<void> _handleFacebookSignIn() async {
    setState(() {
      _isFacebookLoading = true;
    });

    try {
      final userCredential = await FacebookAuthServices().signInWithFacebook();

      if (userCredential != null) {
        setState(() {
          _isFacebookLoading = false;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );

        showSnackBar(
          context,
          '¡Bienvenido ${userCredential.user ?? userCredential.credential}!',
          type: SnackBarType.success,
        );
      } else {
        setState(() {
          _isFacebookLoading = false;
        });
        print('Flujo cancelado por el usuario');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isFacebookLoading = false;
      });
      showSnackBar(
        context,
        'Error de autenticación con Firebase',
        type: SnackBarType.error
      );
    } catch (e) {
      setState(() {
        _isFacebookLoading = false;
      });
      showSnackBar(
        context,
        'Error al iniciar sesión con Facebook',
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
                  child: Image.asset('assets/agence_shop.png', height: 180),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Iniciar Sesión | Bienvenido a Shop Agence',
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
                      Iconsax.user,
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

                // Contraseña
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomObscureText(
                    controller: _passController,
                    validator: PasswordValidator.validatePassword,
                    label: Text('Contraseña', style: textStyles.textStyleLabel),
                    hintText: '****',
                    prefixIcon: Icon(
                      Iconsax.lock,
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

                // Olvidé contraseña
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'forgot_password');
                    },
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: textStyles.textStyleSubTitle,
                    ),
                  ),
                ),

                // Botón Iniciar Sesión
                Align(
                  alignment: Alignment.center,
                  child: _isLoading
                      ? CircularProgressIndicator(color: appTheme.pinkColor)
                      : CustomButton(
                          name: 'Iniciar sesión',
                          onTap: _handleLogin,
                          color: AppTheme.secondaryColor,
                        ),
                ),

                const SizedBox(height: 16),

                // Separador "O"
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: textStyles.textStyleSubTitle.color?.withOpacity(
                          0.3,
                        ),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'O',
                        style: textStyles.textStyleSubTitle.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: textStyles.textStyleSubTitle.color?.withOpacity(
                          0.3,
                        ),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Botón Google
                Align(
                  alignment: Alignment.center,
                  child: _isGoogleLoading
                      ? CircularProgressIndicator(color: appTheme.pinkColor)
                      : ElevatedButton(
                          onPressed: _handleGoogleSignIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/google_icon.png',
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Continuar con Google',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.center,
                  child: _isFacebookLoading
                      ? CircularProgressIndicator(color: appTheme.pinkColor)
                      : ElevatedButton(
                          onPressed: () {
                            _handleFacebookSignIn();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/facebook_icon.png',
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Continuar con Facebook',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),

                const SizedBox(height: 12),

                // Enlace a Registro
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: (_isLoading || _isGoogleLoading)
                        ? null
                        : () {
                            Navigator.pushReplacementNamed(context, 'register');
                          },
                    child: Text(
                      '¿No tienes cuenta? Regístrate',
                      style: textStyles.textStyleSubTitle.copyWith(
                        color: (_isLoading || _isGoogleLoading)
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
