import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_agence/src/data/data_source/services/purchase_services.dart';
import 'package:shop_agence/src/data/models/purchase_model.dart';

// Provider para auth state 
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
});

// Provider para el servicio
final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  return PurchaseService();
});

// Provider para las compras del usuario ACTUAL (reactivo)
final userPurchasesProvider = StreamProvider.autoDispose<List<PurchaseModel>>((
  ref,
) {
  //  Observar cambios en el usuario
  final authState = ref.watch(authStateChangesProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        debugPrint(' No hay usuario autenticado');
        return Stream.value([]);
      }
      debugPrint(
        'Iniciando consulta de compras para: ${user.uid} (${user.email})',
      );
      // Obtener servicio
      final purchaseService = ref.read(purchaseServiceProvider);

      // Usar el método que acepta userId como parámetro
      return purchaseService.getPurchasesByUserId(user.uid);
    },
    loading: () {
      return Stream.value([]);
    },
    error: (error, stack) {
      debugPrint('Error en autenticación: $error');
      return Stream.value([]);
    },
  );
});
