import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  static const String _cartKey = 'shopping_cart';

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
        debugPrint('Carrito cargado: ${loadedCart.length} productos');
      } else {
        debugPrint('No hay datos previos del carrito');
        state = [];
      }
    } catch (e) {
      debugPrint('Error cargando carrito: $e');
      state = [];
    }
  }

  // Guardar carrito en SharedPreferences
  Future<void> _saveCartToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(state.map((item) => item.toMap()).toList());
      await prefs.setString(_cartKey, cartJson);
      debugPrint('Carrito guardado: ${state.length} productos');
    } catch (e) {
      debugPrint('Error guardando carrito: $e');
    }
  }

  // Método para realizar checkout y crear una compra
  PurchaseModel checkout() {
    if (state.isEmpty) {
      throw Exception('El carrito está vacío');
    }

    final purchase = PurchaseModel.fromCart(
      userId: 'current_user', //ID fijo por ahora
      cartItems: List.from(state), // Copia de los items actuales
    );

    // Limpiar el carrito después del checkout
    clearCart();

    return purchase;
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
    final productName = state
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
    debugPrint(
      'Producto removido: $productName, productos restantes: ${state.length}',
    );
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

  void clearCart() {
    state = [];
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
