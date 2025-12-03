import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_agence/src/data/models/purchase_model.dart';

class PurchaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GUARDAR COMPRA 
  Future<String> savePurchase(PurchaseModel purchase) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        throw Exception('Usuario no autenticado');
      }
      if (purchase.userId != user.uid) {
        throw Exception('La compra no pertenece al usuario actual');
      }

      // Verificar si el usuario existe, si no, crearlo
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Guardar la compra en Firestore usando tu modelo
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('purchases')
          .doc(purchase.id)
          .set(purchase.toJson());
      return 'success';
    } catch (e) {
      return 'Error';
    }
  }

  //OBTENER COMPRAS DEL USUARIO 
  Stream<List<PurchaseModel>> getUserPurchases() {
    final user = _auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('purchases')
        .orderBy('purchaseDate', descending: true)
        .snapshots()
        .map((snapshot) {

          return snapshot.docs.map((doc) {
            final data = doc.data();
            try {
              return PurchaseModel.fromJson({'id': doc.id, ...data});
            } catch (e) {
              // Retornar una compra vacía en caso de error
              return PurchaseModel(
                id: doc.id,
                userId: user.uid,
                items: [],
                totalPrice: 0.0,
                purchaseDate: DateTime.now(),
                status: 'error',
              );
            }
          }).toList();
        });
  }

  // OBTENER ESTADÍSTICAS 
  Future<PurchaseStats> getUserPurchaseStats() async {
    try {
      debugPrint('=== OBTENIENDO ESTADÍSTICAS DE COMPRAS ===');

      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('ERROR: Usuario no autenticado');
        throw Exception('Usuario no autenticado');
      }

      debugPrint('Buscando compras para usuario: ${user.uid}');

      // Obtener todas las compras del usuario
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('purchases')
          .get();

      debugPrint('Compras encontradas: ${snapshot.docs.length}');

      // Convertir documentos usando tu PurchaseModel
      final purchases = snapshot.docs.map((doc) {
        final data = doc.data();
        return PurchaseModel.fromJson({'id': doc.id, ...data});
      }).toList();

      // Calcular estadísticas usando tu modelo
      final totalSpent = purchases.fold(
        0.0,
        (sum, purchase) => sum + purchase.totalPrice,
      );

      final totalItems = purchases.fold(0, (sum, purchase) {
        // Sumar todas las cantidades de todos los items en la compra
        return sum +
            purchase.items.fold(0, (itemSum, item) => itemSum + item.quantity);
      });

      final totalProducts = purchases.fold(
        0,
        (sum, purchase) => sum + purchase.items.length,
      );

      final stats = PurchaseStats(
        totalPurchases: purchases.length,
        totalSpent: totalSpent,
        totalItems: totalItems,
        totalProducts: totalProducts,
      );

      return stats;
    } catch (e) {
      debugPrint('ERROR en getUserPurchaseStats: $e');
      rethrow;
    }
  }

  // OBTENER UNA COMPRA ESPECÍFICA
  Future<PurchaseModel?> getPurchaseById(String purchaseId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('purchases')
          .doc(purchaseId)
          .get();

      if (doc.exists) {
        return PurchaseModel.fromJson({'id': doc.id, ...doc.data()!});
      }
      return null;
    } catch (e) {
      debugPrint('Error obteniendo compra $purchaseId: $e');
      return null;
    }
  }

  Stream<List<PurchaseModel>> getPurchasesByUserId(String userId) {
    debugPrint('getPurchasesByUserId llamado para: $userId');

    return _firestore
        .collection('users')
        .doc(userId) // Usar el userId pasado como parámetro
        .collection('purchases')
        .orderBy('purchaseDate', descending: true)
        .snapshots()
        .map((snapshot) {

          return snapshot.docs.map((doc) {
            try {
              return PurchaseModel.fromJson({'id': doc.id, ...doc.data()});
            } catch (e) {
              return PurchaseModel(
                id: doc.id,
                userId: userId,
                items: [],
                totalPrice: 0.0,
                purchaseDate: DateTime.now(),
                status: 'error',
              );
            }
          }).toList();
        });
  }

  // ACTUALIZAR ESTADO DE COMPRA
  Future<String> updatePurchaseStatus(
    String purchaseId,
    String newStatus,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('purchases')
          .doc(purchaseId)
          .update({
            'status': newStatus,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  //ELIMINAR COMPRA 
  Future<String> deletePurchase(String purchaseId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('purchases')
          .doc(purchaseId)
          .delete();

      return 'success';
    } catch (e) {
      debugPrint('Error eliminando compra: $e');
      return e.toString();
    }
  }

  //  OBTENER COMPRAS RECIENTES 
  Stream<List<PurchaseModel>> getRecentPurchases({int limit = 5}) {
    final user = _auth.currentUser;

    if (user == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('purchases')
        .orderBy('purchaseDate', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => PurchaseModel.fromJson({'id': doc.id, ...doc.data()}),
              )
              .toList();
        });
  }

  //OBTENER COMPRAS POR RANGO DE FECHAS 
  Future<List<PurchaseModel>> getPurchasesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('purchases')
          .where(
            'purchaseDate',
            isGreaterThanOrEqualTo: startDate.millisecondsSinceEpoch,
          )
          .where(
            'purchaseDate',
            isLessThanOrEqualTo: endDate.millisecondsSinceEpoch,
          )
          .orderBy('purchaseDate', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PurchaseModel.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      debugPrint('Error obteniendo compras por rango: $e');
      return [];
    }
  }
}

// MODELO DE ESTADÍSTICAS 
class PurchaseStats {
  final int totalPurchases;
  final double totalSpent;
  final int totalItems; 
  final int totalProducts; 

  PurchaseStats({
    required this.totalPurchases,
    required this.totalSpent,
    required this.totalItems,
    required this.totalProducts,
  });
  factory PurchaseStats.empty() {
    return PurchaseStats(
      totalPurchases: 0,
      totalSpent: 0.0,
      totalItems: 0,
      totalProducts: 0,
    );
  }

  // Métodos auxiliares
  double get averagePerPurchase =>
      totalPurchases > 0 ? totalSpent / totalPurchases : 0.0;

  double get averageItemsPerPurchase =>
      totalPurchases > 0 ? totalItems / totalPurchases : 0.0;

  double get averageProductsPerPurchase =>
      totalPurchases > 0 ? totalProducts / totalPurchases : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'totalPurchases': totalPurchases,
      'totalSpent': totalSpent,
      'totalItems': totalItems,
      'totalProducts': totalProducts,
      'averagePerPurchase': averagePerPurchase,
      'averageItemsPerPurchase': averageItemsPerPurchase,
      'averageProductsPerPurchase': averageProductsPerPurchase,
    };
  }
  
  String get formattedTotalSpent => '\$${totalSpent.toStringAsFixed(2)}';
  String get formattedAveragePerPurchase =>
      '\$${averagePerPurchase.toStringAsFixed(2)}';
  String get formattedAverageItems =>
      averageItemsPerPurchase.toStringAsFixed(1);
}
