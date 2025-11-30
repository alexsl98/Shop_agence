import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_agence/firebase_options.dart';
import 'package:shop_agence/src/core/theme/app_theme.dart';
import 'package:shop_agence/src/presentation/provider/theme_provider/theme_provider.dart';
import 'package:shop_agence/src/presentation/screens/auth/forgot_password_screen.dart';
import 'package:shop_agence/src/presentation/screens/auth/login_screen.dart';
import 'package:shop_agence/src/presentation/screens/auth/register_screen.dart';
import 'package:shop_agence/src/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Precargar el tema al iniciar
    _preloadTheme();
  }

  Future<void> _preloadTheme() async {
    await ref.read(initialThemeProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = ref.watch(themeProvider);
    print('Iniciando app con tema: ${darkMode ? 'Oscuro' : 'Claro'}');

    return MaterialApp(
      theme: AppTheme(isDarkmode: darkMode).getTheme(),
      title: 'Finanzi',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        'register': (context) => RegisterScreen(),
        'home': (context) => HomeScreen(),
        'forgot_password': (context) => ForgotPasswordScreen(),
      },
    );
  }
}
