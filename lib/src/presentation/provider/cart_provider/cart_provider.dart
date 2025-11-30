import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:shop_agence/src/data/models/product_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;

  // Métodos para serialización compatibles con tu ProductModel
  Map<String, dynamic> toMap() {
    return {
      'product': product.toJson(), // Usa toJson() de tu ProductModel
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: ProductModel.fromJson(
        map['product'],
      ), // Usa fromJson() de tu ProductModel
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
    _loadCartFromPrefs(); // Cargar datos al iniciar
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
      state = []; // En caso de error, empezar con carrito vacío
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

  void addProduct(ProductModel product) {
    final index = state.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      state = state.map((item) {
        if (item.product.id == product.id) {
          debugPrint(
            'Producto existente, nueva cantidad: ${item.quantity + 1}',
          );
          return CartItem(product: item.product, quantity: item.quantity + 1);
        }
        return item;
      }).toList();
    } else {
      debugPrint('Nuevo producto añadido: ${product.title}');
      state = [...state, CartItem(product: product)];
    }

    debugPrint(
      'Estado final: ${state.length} productos, ${state.fold(0, (sum, item) => sum + item.quantity)} items total',
    );

    _saveCartToPrefs(); // Guardar después del cambio
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
    _saveCartToPrefs(); // Guardar después del cambio
  }

  void updateQuantity(int productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeProduct(productId);
      return;
    }

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

    state = state.map((item) {
      if (item.product.id == productId) {
        debugPrint('Cantidad actualizada: $productName -> $newQuantity');
        return CartItem(product: item.product, quantity: newQuantity);
      }
      return item;
    }).toList();

    _saveCartToPrefs(); // Guardar después del cambio
  }

  void clearCart() {
    state = [];
    debugPrint('Carrito vaciado completamente');
    _saveCartToPrefs(); // Guardar después del cambio
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

  // Método para obtener un producto específico del carrito
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
