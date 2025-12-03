import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_agence/src/data/data_source/services/session_manager_services.dart';
import 'package:shop_agence/src/data/models/user_model.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para guardar timestamp
  Future<void> _saveLoginTimestamp() async {
    if (_auth.currentUser != null) {
      await SessionManager.saveLoginTimestamp(_auth.currentUser!.uid);
    }
  }

  // SignUp User - Usando UserModel directamente
  Future<UserModel> signupUser(UserModel user) async {
    try {
      // Validar campos obligatorios usando el objeto user
      if (user.email.isEmpty) {
        throw Exception("El email es obligatorio");
      }
      if (user.password.isEmpty) {
        throw Exception("La contraseña es obligatoria");
      }
      if (user.name.isEmpty) {
        throw Exception("El nombre es obligatorio");
      }
      if (user.address.isEmpty) {
        throw Exception("La dirección es obligatoria");
      }

      // Registrar usuario en Authentication
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      // Obtener el UID del usuario creado
      final String uid = cred.user!.uid;

      // Guardar usuario en Firestore
      await _firestore.collection("users").doc(uid).set({
        'uid': uid,
        'email': user.email,
        'address': user.address,
        'name': user.name,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Guardar timestamp del login
      await _saveLoginTimestamp();

      print('Usuario registrado exitosamente: $uid');

      // Retornar el mismo UserModel (sin password por seguridad)
      return UserModel(
        email: user.email,
        password: '', // No retornamos la contraseña por seguridad
        address: user.address,
        name: user.name,
      );
    } on FirebaseAuthException catch (e) {
      // Manejar errores específicos de Firebase Auth
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'El correo electrónico ya está en uso';
          break;
        case 'invalid-email':
          errorMessage = 'Correo electrónico inválido';
          break;
        case 'weak-password':
          errorMessage = 'La contraseña debe tener al menos 6 caracteres';
          break;
        case 'operation-not-allowed':
          errorMessage = 'El registro con email/password no está habilitado';
          break;
        default:
          errorMessage = 'Error en el registro: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      // Manejar otros errores
      throw Exception('Error en el registro: $e');
    }
  }

  // Login user - Usando email y password
  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Validar campos
      if (email.isEmpty) {
        throw Exception("Ingrese su email");
      }
      if (password.isEmpty) {
        throw Exception("Ingrese su contraseña");
      }

      // Iniciar sesión con email y password
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Obtener datos del usuario desde Firestore
      if (_auth.currentUser != null) {
        final String uid = _auth.currentUser!.uid;

        DocumentSnapshot userDoc = await _firestore
            .collection("users")
            .doc(uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

          // Crear UserModel desde los datos de Firestore
          UserModel user = UserModel(
            email: data['email'] ?? '',
            password: '', 
            address: data['address'] ?? '',
            name: data['name'] ?? '',
          );

          // Guardar timestamp del login
          await _saveLoginTimestamp();

          print('Usuario autenticado: ${user.email}');
          return user;
        } else {
          throw Exception("Usuario no encontrado en la base de datos");
        }
      } else {
        throw Exception("Error al obtener el usuario autenticado");
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No existe una cuenta con este email';
          break;
        case 'wrong-password':
          errorMessage = 'Contraseña incorrecta';
          break;
        case 'user-disabled':
          errorMessage = 'Esta cuenta ha sido deshabilitada';
          break;
        case 'too-many-requests':
          errorMessage = 'Demasiados intentos. Intente más tarde';
          break;
        case 'invalid-email':
          errorMessage = 'Formato de email inválido';
          break;
        default:
          print('DEBUG: Código de error no manejado: ${e.code}');
          errorMessage = 'Email o contraseña incorrecta';
      }
      print('DEBUG: Lanzando excepción: $errorMessage');
      throw Exception(errorMessage);
    } catch (e) {
      print('DEBUG: Error genérico: $e');
      throw Exception('Error en el login: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await SessionManager.clearSessionData();
  }

  // Método para verificar sesión al iniciar la app
  Future<bool> checkExistingSession() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // verificar timeout de 2 horas
        bool isValid = await SessionManager.checkAndUpdateSession();
        if (isValid) {
          return true;
        } else {
          await signOut();
          return false;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
