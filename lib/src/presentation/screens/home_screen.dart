import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop_agence/src/data/data_source/services/auth_services.dart';
import 'package:shop_agence/src/data/data_source/services/google_auth_services.dart';
import 'package:shop_agence/src/presentation/screens/auth/login_screen.dart';
import 'package:shop_agence/src/presentation/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    String capitalize(String text) {
      if (text.isEmpty) return text;
      return text[0].toUpperCase() + text.substring(1).toLowerCase();
    }

    // Obtener el nombre de usuario (displayName o email)
    String getUsername() {
      if (user?.displayName != null && user!.displayName!.isNotEmpty) {
        return user.displayName!;
      } else if (user?.email != null) {
        // Usar el email sin el dominio como nombre de usuario
        return user!.email!.split('@')[0];
      }
      return 'Usuario';
    }

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Iconsax.menu_1),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthMethod().signOut();
              await GoogleAuthServices().signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: Icon(Iconsax.logout),
          ),
        ],

        title: const Text("Home"),
      ),
      drawer: CustomDrawer(),
      body: Center(child: Text("Bienvenido ${capitalize(getUsername())}")),
    );
  }
}
