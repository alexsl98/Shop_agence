// purchases_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:shop_agence/src/data/models/purchase_model.dart';

final purchasesProvider =
    StateNotifierProvider<PurchasesNotifier, List<PurchaseModel>>((ref) {
      return PurchasesNotifier();
    });

class PurchasesNotifier extends StateNotifier<List<PurchaseModel>> {
  PurchasesNotifier() : super([]) {
    _loadPurchases();
  }

  static const String _purchasesKey = 'user_purchases';

  Future<void> _loadPurchases() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final purchasesJson = prefs.getString(_purchasesKey);

      if (purchasesJson != null && purchasesJson.isNotEmpty) {
        final List<dynamic> purchasesData = json.decode(purchasesJson);
        final List<PurchaseModel> loadedPurchases = purchasesData
            .map(
              (purchase) =>
                  PurchaseModel.fromJson(purchase as Map<String, dynamic>),
            )
            .toList();

        state = loadedPurchases;
      } else {
        state = [];
      }
    } catch (e) {
      state = [];
    }
  }

  Future<void> _savePurchases() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final purchasesJson = json.encode(
        state.map((purchase) => purchase.toJson()).toList(),
      );
      await prefs.setString(_purchasesKey, purchasesJson);
    } catch (e) {
      debugPrint('Error guardando compras: $e');
    }
  }

  void addPurchase(PurchaseModel purchase) {
    state = [purchase, ...state]; // Agregar al inicio de la lista
    _savePurchases();
  }

  // Obtener compras ordenadas por fecha (más reciente primero)
  List<PurchaseModel> get sortedPurchases {
    return List.from(state)
      ..sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
  }

  // Obtener el total gastado
  double get totalSpent {
    return state.fold(0.0, (sum, order) => sum + order.totalPrice);
  }

  // Obtener número total de compras
  int get totalPurchases {
    return state.length;
  }
}
