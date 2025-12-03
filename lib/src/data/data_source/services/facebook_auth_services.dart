import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookAuthServices {
  // Inicia sesión con Facebook
  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );
      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);

        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        return userCredential;
      } else if (loginResult.status == LoginStatus.cancelled) {
        // El usuario canceló el inicio de sesión
        print('Inicio de sesión con Facebook cancelado por el usuario.');
        return null;
      } else {
        print(
          'Error durante el inicio de sesión con Facebook: ${loginResult.message}',
        );
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print('Error de Firebase Auth en Facebook: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error inesperado en Facebook Auth: $e');
      rethrow;
    }
  }

  // Cierra la sesión de Facebook
  Future<void> signOut() async {
    await FacebookAuth.instance.logOut();
  }

  // Obtiene los datos del usuario de Facebook
  Future<Map<String, dynamic>?> getUserData() async {
    return await FacebookAuth.instance.getUserData();
  }
}
