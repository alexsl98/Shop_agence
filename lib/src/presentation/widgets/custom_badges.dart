import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_agence/src/presentation/provider/cart_provider/cart_provider.dart'; // ✅ Importa desde aquí

class CartBadge extends ConsumerWidget {
  final Widget? child;
  final double badgeSize;
  final Color badgeColor;

  const CartBadge({
    super.key,
    this.child,
    this.badgeSize = 20,
    this.badgeColor = Colors.red,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartCountProvider); 
    debugPrint('CartBadge - Cart count: $cartCount'); // Para debug

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child ?? const Icon(Icons.shopping_cart_outlined),
        if (cartCount > 0)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              height: badgeSize,
              width: badgeSize,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Center(
                child: Text(
                  cartCount > 99 ? '99+' : cartCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: badgeSize * 0.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
