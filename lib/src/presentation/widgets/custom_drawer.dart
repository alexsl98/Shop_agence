import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth
import 'package:iconsax/iconsax.dart';
import 'package:shop_agence/src/core/theme/app_theme.dart';
import 'package:shop_agence/src/core/theme/text_styles.dart';
import 'package:shop_agence/src/presentation/provider/theme_provider/theme_provider.dart';
import 'package:shop_agence/src/data/data_source/services/auth_services.dart';
import 'package:shop_agence/src/data/data_source/services/google_auth_services.dart';
import 'package:shop_agence/src/presentation/screens/auth/login_screen.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final appTheme = AppTheme(isDarkmode: isDarkMode);

    // Obtener el usuario actual de Firebase Auth
    final User? user = FirebaseAuth.instance.currentUser;

    String capitalize(String text) {
      if (text.isEmpty) return text;
      return text[0].toUpperCase() + text.substring(1).toLowerCase();
    }

    // Obtener el nombre de usuario (displayName o email)
    String getUsername() {
      if (user?.displayName != null && user!.displayName!.isNotEmpty) {
        final names = user.displayName!.split(' ');
        return names[0]; // Solo el primer nombre
      } else if (user?.email != null) {
        // Usar el email sin el dominio como nombre de usuario
        return user!.email!.split('@')[0];
      }
      return 'Usuario';
    }

    return Drawer(
      child: Material(
        color: appTheme.drawerBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: appTheme.drawerBackgroundColor),
              currentAccountPicture: CircleAvatar(
                backgroundColor: appTheme.drawerForegroundColor,
                child: Icon(
                  Iconsax.user,
                  size: 40,
                  color: appTheme.drawerBackgroundColor,
                ),
              ),
              otherAccountsPictures: [
                IconButton(
                  onPressed: () {
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
                  icon: Icon(
                    isDarkMode ? Iconsax.moon : Iconsax.sun_15,
                    color: appTheme.drawerForegroundColor,
                    size: 28,
                  ),
                ),
              ],
              accountName: Text(
                'Bienvenido, ${capitalize(getUsername())}',
                style: textStyleTextConten.copyWith(
                  color: appTheme.drawerForegroundColor,
                ),
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              accountEmail: Text(
                user?.email ?? 'No hay email',
                style: textStyleTextConten.copyWith(
                  color: appTheme.drawerForegroundColor,
                ),
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ListTile(
              leading: Icon(
                Iconsax.home,
                color: appTheme.drawerForegroundColor,
              ),
              title: Text(
                'Home',
                style: textDrawer.copyWith(
                  color: appTheme.drawerForegroundColor,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'home');
              },
            ),
            ListTile(
              leading: Icon(
                Iconsax.user,
                color: appTheme.drawerForegroundColor,
              ),
              title: Text(
                'Perfil',
                style: textDrawer.copyWith(
                  color: appTheme.drawerForegroundColor,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'profile');
              },
            ),
            ListTile(
              leading: Icon(
                Iconsax.shop,
                color: appTheme.drawerForegroundColor,
              ),
              title: Text(
                'Mis productos',
                style: textDrawer.copyWith(
                  color: appTheme.drawerForegroundColor,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'configuracion');
              },
            ),
            ListTile(
              leading: Icon(
                Iconsax.setting,
                color: appTheme.drawerForegroundColor,
              ),
              title: Text(
                'Configuración',
                style: textDrawer.copyWith(
                  color: appTheme.drawerForegroundColor,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'configuracion');
              },
            ),
            ListTile(
              leading: Icon(
                Iconsax.logout,
                color: appTheme.drawerForegroundColor,
              ),
              title: Text(
                'Cerrar sesión',
                style: textDrawer.copyWith(
                  color: appTheme.drawerForegroundColor,
                ),
              ),
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.cardColor,
        title: Text(
          'Cerrar Sesión',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: Text(
          '¿Estás seguro de que quieres cerrar sesión?',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Cerrar diálogo
              await _performLogout(context);
            },
            child: Text(
              'Cerrar Sesión',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // ✅ EJECUTAR AMBOS MÉTODOS DE LOGOUT
      await AuthMethod().signOut();
      await GoogleAuthServices().signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Sesión cerrada exitosamente'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error al cerrar sesión: $e');

      // Cerrar el loading si hay error
      if (context.mounted) {
        Navigator.of(context).pop(); // Cerrar loading
      }

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error al cerrar sesión: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
