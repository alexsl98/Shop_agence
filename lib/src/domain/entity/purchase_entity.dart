class PurchaseEntity {
  final String id;
  final String userId;
  final List<PurchaseItemEntityList> items;
  final double totalPrice;
  final DateTime purchaseDate;
  final String status;

  PurchaseEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.purchaseDate,
    required this.status,
  });
}

class PurchaseItemEntityList {
  final String productId;
  final String productTitle;
  final double productPrice;
  final String productImage;
  final String productCategory;
  final int quantity;
  final double totalPrice;

  PurchaseItemEntityList({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productImage,
    required this.productCategory,
    required this.quantity,
    required this.totalPrice,
  });
}
