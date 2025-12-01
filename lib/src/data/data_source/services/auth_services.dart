import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_agence/src/data/data_source/services/session_manager_services.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para guardar timestamp
  Future<void> _saveLoginTimestamp() async {
    if (_auth.currentUser != null) {
      await SessionManager.saveLoginTimestamp(_auth.currentUser!.uid);
    }
  }

  // SignUp User
  Future<String> signupUser({
    required String email,
    required String password,
    required String address,
    required String name,
  }) async {
    String res = "Ocurrió un error inesperado";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          address.isNotEmpty ||
          name.isNotEmpty) {
        // register user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // add user to your  firestore database
        print(cred.user!.uid);
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'name': name,
          'uid': cred.user!.uid,
          'email': email,
          'address': address,
        });
        // Guardar timestamp del login
        await _saveLoginTimestamp();
        res = "success";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logIn user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Ocurrió un error inesperado";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Guardar timestamp del login
        await _saveLoginTimestamp();
        res = "success";
      } else {
        res = "Por favor ingrese todos los campos";
      }
    } catch (err) {
      return res;
    }
    return res;
  }

  // for sighout
  Future<void> signOut() async {
    await _auth.signOut();
    await SessionManager.clearSessionData();
  }

  // Método para verificar sesión al iniciar la app
  Future<bool> checkExistingSession() async {
    try {
      // Primero verificar con Firebase Auth
      User? user = _auth.currentUser;

      if (user != null) {
        // Luego verificar nuestro timeout de 2 horas
        bool isValid = await SessionManager.checkAndUpdateSession();

        if (isValid) {
          print('Sesión válida para el usuario: ${user.email}');
          return true;
        } else {
          print('Sesión expirada, cerrando...');
          await signOut();
          return false;
        }
      }
      return false;
    } catch (e) {
      print('Error verificando sesión: $e');
      return false;
    }
  }
}
