import 'package:shop_agence/src/data/models/product_model.dart';
import 'package:shop_agence/src/domain/entity/purchase_entity.dart';
import 'package:shop_agence/src/presentation/provider/cart_provider/cart_provider.dart';

class PurchaseModel extends PurchaseEntity {
  PurchaseModel({
    required super.id,
    required super.userId,
    required super.items,
    required super.totalPrice,
    required super.purchaseDate,
    required super.status,
  });

  // Constructor para crear desde el carrito
  factory PurchaseModel.fromCart({
    required String userId,
    required List<CartItem> cartItems,
  }) {
    final items = cartItems
        .map((cartItem) => PurchaseItemModel.fromCartItem(cartItem))
        .toList();

    final totalPrice = cartItems.fold(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );

    return PurchaseModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      items: items.cast<PurchaseItemEntityList>(),
      totalPrice: totalPrice,
      purchaseDate: DateTime.now(),
      status: 'completed',
    );
  }

  // Conversión desde JSON/Map
  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List)
          .map((item) => PurchaseItemModel.fromJson(item))
          .cast<PurchaseItemEntityList>()
          .toList(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      purchaseDate: DateTime.fromMillisecondsSinceEpoch(json['purchaseDate']),
      status: json['status'],
    );
  }

  // Conversión a JSON/Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items
          .map((item) => (item as PurchaseItemModel).toJson())
          .toList(),
      'totalPrice': totalPrice,
      'purchaseDate': purchaseDate.millisecondsSinceEpoch,
      'status': status,
    };
  }
}

class PurchaseItemModel extends PurchaseItemEntityList {
  PurchaseItemModel({
    required super.productId,
    required super.productTitle,
    required super.productPrice,
    required super.productImage,
    required super.productCategory,
    required super.quantity,
    required super.totalPrice,
  });

  // Constructor desde CartItem
  factory PurchaseItemModel.fromCartItem(CartItem cartItem) {
    return PurchaseItemModel(
      productId: cartItem.product.id.toString(),
      productTitle: cartItem.product.title,
      productPrice: cartItem.product.price,
      productImage: cartItem.product.image,
      productCategory: cartItem.product.category,
      quantity: cartItem.quantity,
      totalPrice: cartItem.totalPrice,
    );
  }

  // Constructor desde ProductModel
  factory PurchaseItemModel.fromProduct(
    ProductModel product, {
    int quantity = 1,
  }) {
    return PurchaseItemModel(
      productId: product.id.toString(),
      productTitle: product.title,
      productPrice: product.price,
      productImage: product.image,
      productCategory: product.category,
      quantity: quantity,
      totalPrice: product.price * quantity,
    );
  }

  // Conversión desde JSON/Map
  factory PurchaseItemModel.fromJson(Map<String, dynamic> json) {
    return PurchaseItemModel(
      productId: json['productId'],
      productTitle: json['productTitle'],
      productPrice: (json['productPrice'] as num).toDouble(),
      productImage: json['productImage'],
      productCategory: json['productCategory'],
      quantity: json['quantity'],
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }

  // Conversión a JSON/Map
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productTitle': productTitle,
      'productPrice': productPrice,
      'productImage': productImage,
      'productCategory': productCategory,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }
}
