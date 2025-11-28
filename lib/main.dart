import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shop_agence/firebase_options.dart';
import 'package:shop_agence/src/presentation/screens/auth/forgot_password_screen.dart';
import 'package:shop_agence/src/presentation/screens/auth/login_screen.dart';
import 'package:shop_agence/src/presentation/screens/home_screen.dart';
import 'package:shop_agence/src/presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/forgot_password': (context) => ForgotPasswordScreen(),
      },
    );
  }
}
