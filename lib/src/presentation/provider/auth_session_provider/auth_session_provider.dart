// auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_agence/src/data/data_source/services/session_manager_services.dart';

// Provider para Firebase Auth
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Stream de cambios en la autenticación
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
});

// Provider que combina autenticación Firebase + nuestra validación de 2 horas
final authSessionProvider = FutureProvider<AuthSessionState>((ref) async {
  final auth = ref.watch(firebaseAuthProvider);
  final user = auth.currentUser;

  if (user == null) {
    return AuthSessionState(
      user: null,
      isSessionValid: false,
      isLoading: false,
    );
  }

  // Verificar nuestra sesión de 2 horas
  final isSessionValid = await SessionManager.checkAndUpdateSession();

  return AuthSessionState(
    user: user,
    isSessionValid: isSessionValid,
    isLoading: false,
  );
});

class AuthSessionState {
  final User? user;
  final bool isSessionValid;
  final bool isLoading;

  const AuthSessionState({
    this.user,
    this.isSessionValid = false,
    this.isLoading = true,
  });
}
