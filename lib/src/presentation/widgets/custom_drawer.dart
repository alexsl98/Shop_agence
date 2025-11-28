import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop_agence/src/core/theme/app_theme.dart';
import 'package:shop_agence/src/core/theme/text_styles.dart';
import 'package:shop_agence/src/domain/entity/user.dart';
import 'package:shop_agence/src/presentation/provider/theme_provider/theme_provider.dart';

class CustomDrawer extends ConsumerWidget {
  final UserEntity user;

  const CustomDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final appTheme = AppTheme(isDarkmode: isDarkMode);

    String capitalize(String text) {
      if (text.isEmpty) return text;
      return text[0].toUpperCase() + text.substring(1).toLowerCase();
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
                child: Text(
                  user.username!.isNotEmpty
                      ? user.username![0].toUpperCase()
                      : '?',
                  style: textStyleTextConten.copyWith(
                    color: appTheme.drawerBackgroundColor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
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
                'Bienvenido, ${capitalize(user.username ?? '')}',
                style: textStyleTextConten.copyWith(
                  color: appTheme.drawerForegroundColor,
                ),
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              accountEmail: Text(
                user.email,
                style: textStyleTextConten.copyWith(
                  color: appTheme.drawerForegroundColor,
                ),
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Todos los ListTiles
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
                Navigator.pushNamed(context, 'home', arguments: user);
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
                Navigator.pushNamed(context, 'profile', arguments: user);
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
                Navigator.pushNamed(context, 'configuracion', arguments: user);
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
                Navigator.pushNamed(context, 'configuracion', arguments: user);
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
              Navigator.pop(context);
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
      //final logoutUseCase = sl<LogoutUseCase>();
      // await logoutUseCase.call();

      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);

      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Sesión cerrada exitosamente'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    } catch (_) {
      print('Error al cerrar sesión');
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Hubo un problema al cerrar sesión.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}
