// auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_agence/src/data/data_source/services/session_manager_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_agence/src/presentation/provider/auth_session_provider/auth_session_provider.dart';

class AuthWrapper extends ConsumerWidget {
  final Widget signedInWidget;
  final Widget signedOutWidget;

  const AuthWrapper({
    Key? key,
    required this.signedInWidget,
    required this.signedOutWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSession = ref.watch(authSessionProvider);

    return authSession.when(
      loading: () => _buildLoadingScreen(),
      error: (error, stackTrace) {
        print('Error en autenticación: $error');
        return _buildErrorScreen(error.toString());
      },
      data: (sessionState) {
        // Si hay usuario y sesión válida
        if (sessionState.user != null && sessionState.isSessionValid) {
          return signedInWidget;
        }

        // Si hay usuario pero sesión expirada
        if (sessionState.user != null && !sessionState.isSessionValid) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleExpiredSession(context, ref);
          });
          return _buildLoadingScreen(); // O signedOutWidget
        }

        // No hay usuario autenticado
        return signedOutWidget;
      },
    );
  }

  Widget _buildLoadingScreen() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Verificando sesión...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String error) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 50, color: Colors.red),
            const SizedBox(height: 20),
            const Text('Error de autenticación'),
            const SizedBox(height: 10),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Intentar recargar
                // ref.invalidate(authSessionProvider);
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleExpiredSession(BuildContext context, WidgetRef ref) async {
    try {
      await FirebaseAuth.instance.signOut();
      await SessionManager.clearSessionData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tu sesión ha expirado. Por favor inicia sesión nuevamente.',
          ),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('Error al cerrar sesión expirada: $e');
    }
  }
}
