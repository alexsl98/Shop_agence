import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart'; // AÑADIR IMPORT
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:shop_agence/src/data/models/product_model.dart';
import 'package:shop_agence/src/data/models/purchase_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {'product': product.toJson(), 'quantity': quantity};
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: ProductModel.fromJson(map['product']),
      quantity: map['quantity'] ?? 1,
    );
  }
}

final cartItemsProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((
  ref,
) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]) {
    _loadCartFromPrefs();
  }

  String get _cartKey {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? 'anonymous';
    return 'shopping_cart_$userId';
  }

  // Cargar carrito desde SharedPreferences
  Future<void> _loadCartFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);

      if (cartJson != null && cartJson.isNotEmpty) {
        final List<dynamic> cartData = json.decode(cartJson);
        final List<CartItem> loadedCart = cartData
            .map((item) => CartItem.fromMap(item as Map<String, dynamic>))
            .toList();

        state = loadedCart;
      } else {
        state = [];
      }
    } catch (e) {
      state = [];
    }
  }

  void onUserChanged() {
    _loadCartFromPrefs();
  }

  // Guardar carrito en SharedPreferences
  Future<void> _saveCartToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(state.map((item) => item.toMap()).toList());
      await prefs.setString(_cartKey, cartJson);
    } catch (e) {
      debugPrint('Error guardando carrito: $e');
    }
  }

  // MÉTODO CHECKOUT
  PurchaseModel checkout() {
    debugPrint('=== CHECKOUT INICIADO ===');

    if (state.isEmpty) {
      debugPrint('ERROR: El carrito está vacío');
      throw Exception('El carrito está vacío');
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('ERROR: Usuario no autenticado');
      throw Exception('Usuario no autenticado');
    }

    // Crear la compra
    final purchase = PurchaseModel.fromCart(
      userId: user.uid,
      cartItems: List.from(state),
    );
    return purchase;
  }

  // Método para limpiar después del éxito
  void completeCheckout() {
    clearCart();
  }

  void clearCart() {
    state = [];
    _saveCartToPrefs();
  }

  void addProduct(ProductModel product) {
    final index = state.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      state = state.map((item) {
        if (item.product.id == product.id) {
          return CartItem(product: item.product, quantity: item.quantity + 1);
        }
        return item;
      }).toList();
    } else {
      state = [...state, CartItem(product: product)];
    }

    _saveCartToPrefs();
  }

  void removeProduct(int productId) {
    state
        .firstWhere(
          (item) => item.product.id == productId,
          orElse: () => CartItem(
            product: ProductModel(
              id: -1,
              title: '',
              price: 0.0,
              description: '',
              category: '',
              image: '',
              rate: 0.0,
              count: 0,
            ),
            quantity: 0,
          ),
        )
        .product
        .title;

    state = state.where((item) => item.product.id != productId).toList();
    _saveCartToPrefs();
  }

  void updateQuantity(int productId, int newQuantity) {
    if (newQuantity < 1) {
      return;
    }

    state
        .firstWhere(
          (item) => item.product.id == productId,
          orElse: () => CartItem(
            product: ProductModel(
              id: -1,
              title: '',
              price: 0.0,
              description: '',
              category: '',
              image: '',
              rate: 0.0,
              count: 0,
            ),
            quantity: 0,
          ),
        )
        .product
        .title;

    state = state.map((item) {
      if (item.product.id == productId) {
        return CartItem(product: item.product, quantity: newQuantity);
      }
      return item;
    }).toList();

    _saveCartToPrefs();
  }

  // Métodos adicionales útiles
  double get totalPrice {
    return state.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItems {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }

  bool isProductInCart(int productId) {
    return state.any((item) => item.product.id == productId);
  }

  int getProductQuantity(int productId) {
    final item = state.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(
        product: ProductModel(
          id: -1,
          title: '',
          price: 0.0,
          description: '',
          category: '',
          image: '',
          rate: 0.0,
          count: 0,
        ),
        quantity: 0,
      ),
    );
    return item.quantity;
  }

  ProductModel? getProductById(int productId) {
    try {
      return state.firstWhere((item) => item.product.id == productId).product;
    } catch (e) {
      return null;
    }
  }
}

// Provider para el contador total
final cartCountProvider = Provider<int>((ref) {
  final cartItems = ref.watch(cartItemsProvider);
  return cartItems.fold(0, (total, item) => total + item.quantity);
});

// Provider para el precio total
final cartTotalPriceProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartItemsProvider);
  return cartItems.fold(0.0, (total, item) => total + item.totalPrice);
});

// Provider para verificar si el carrito está vacío
final cartIsEmptyProvider = Provider<bool>((ref) {
  final cartItems = ref.watch(cartItemsProvider);
  return cartItems.isEmpty;
});

// Provider para observar cambios de usuario y actualizar carrito
final cartAuthObserverProvider = Provider((ref) {
  final auth = FirebaseAuth.instance;
  final cartNotifier = ref.read(cartItemsProvider.notifier);

  // Escuchar cambios de autenticación
  auth.authStateChanges().listen((user) {
    if (user != null) {
      debugPrint('Cart: Usuario cambiado a: ${user.email} (${user.uid})');
      debugPrint(' Cart: Key actual: shopping_cart_${user.uid}');
    } else {
      debugPrint('Cart: Usuario desconectado');
      debugPrint('Cart: Key actual: shopping_cart_anonymous');
    }

    // Recargar carrito para el nuevo usuario
    cartNotifier.onUserChanged();
  });

  return null;
});
