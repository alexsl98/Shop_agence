import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop_agence/src/core/theme/app_theme.dart';
import 'package:shop_agence/src/core/theme/text_styles.dart';
import 'package:shop_agence/src/presentation/provider/cart_provider/cart_provider.dart';
import 'package:shop_agence/src/presentation/provider/purchase_provider/purchases_provider.dart';
import 'package:shop_agence/src/presentation/provider/theme_provider/theme_provider.dart';
import 'package:shop_agence/src/presentation/widgets/snack_bar.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final appTheme = AppTheme(isDarkmode: isDarkMode);
    final cartItems = ref.watch(cartItemsProvider);
    final cartNotifier = ref.read(cartItemsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mi Carrito',
          style: textAppBar.copyWith(color: appTheme.drawerForegroundColor),
        ),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Iconsax.trash),
              onPressed: () {
                _showClearCartDialog(context, cartNotifier);
              },
              tooltip: 'Vaciar carrito',
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart()
          : _buildCartList(cartItems, cartNotifier, ref),
      bottomNavigationBar: cartItems.isNotEmpty
          ? _buildTotalBar(cartItems, context, ref)
          : null,
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.shopping_cart, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            'Tu carrito está vacío',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Añade algunos productos desde la tienda',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(
    List<CartItem> cartItems,
    CartNotifier cartNotifier,
    WidgetRef ref,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return _buildCartItem(item, cartNotifier, context, ref);
      },
    );
  }

  Widget _buildCartItem(
    CartItem item,
    CartNotifier cartNotifier,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Imagen del producto
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.product.image,
                width: 60,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 90,
                  color: Colors.grey[200],
                  child: const Icon(Iconsax.gallery_slash, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Información del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.product.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  // Controles de cantidad
                  Row(
                    children: [
                      // Botón decrementar
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          icon: const Icon(Iconsax.minus, size: 18),
                          onPressed: () {
                            cartNotifier.updateQuantity(
                              item.product.id,
                              item.quantity - 1,
                            );
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),

                      // Cantidad
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          item.quantity.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      // Botón incrementar
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          icon: const Icon(Iconsax.add, size: 18),
                          onPressed: () {
                            cartNotifier.updateQuantity(
                              item.product.id,
                              item.quantity + 1,
                            );
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Botón eliminar
            Column(
              children: [
                IconButton(
                  icon: const Icon(Iconsax.trash, color: Colors.red),
                  onPressed: () {
                    cartNotifier.removeProduct(item.product.id);
                    _showRemovedSnackBar(context, item.product.title);
                  },
                ),
                SizedBox(height: 16),
                IconButton(
                  icon: const Icon(Iconsax.location, color: Colors.green),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalBar(
    List<CartItem> cartItems,
    BuildContext context,
    WidgetRef ref,
  ) {
    final totalPrice = cartItems.fold(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );

    final cartNotifier = ref.read(cartItemsProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total:',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {
              _showCheckoutDialog(context, totalPrice, cartNotifier, ref);
            },
            icon: const Icon(Iconsax.shopping_bag),
            label: const Text('Finalizar Compra'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartNotifier cartNotifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vaciar carrito'),
        content: const Text(
          '¿Estás seguro de que quieres vaciar todo el carrito?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              cartNotifier.clearCart();
              Navigator.pop(context);
              _showClearedSnackBar(context);
            },
            child: const Text('Vaciar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog(
    BuildContext context,
    double totalPrice,
    CartNotifier cartNotifier,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalizar Compra'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total a pagar: \$${totalPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text(
              '¿Estás seguro de que quieres proceder con la compra?',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _processCheckout(context, cartNotifier, ref);
            },
            child: const Text('Confirmar Compra'),
          ),
        ],
      ),
    );
  }

  Future<void> _processCheckout(
    BuildContext context,
    CartNotifier cartNotifier,
    WidgetRef ref,
  ) async {
    try {
      final purchase = cartNotifier.checkout();
      // Guardar la orden en el provider de compras
      final purchasesNotifier = ref.read(purchasesProvider.notifier);
      purchasesNotifier.addPurchase(purchase);
      // Mostrar mensaje de éxito
      _showOrderConfirmedSnackBar(context);
      Navigator.pushNamed(context, 'mis_compras');
    } catch (e) {
      if (context.mounted) {
        _showCheckoutErrorSnackBar(context);
      }
    }
  }

  void _showCheckoutErrorSnackBar(BuildContext context) {
    showSnackBar(
      context,
      'Error al procesar la compra. Intenta nuevamente.',
      type: SnackBarType.error,
    );
  }

  void _showRemovedSnackBar(BuildContext context, String productName) {
    showSnackBar(
      context,
      '$productName removido del carrito',
      type: SnackBarType.warning,
    );
  }

  void _showClearedSnackBar(BuildContext context) {
    showSnackBar(context, 'Carrito vaciado', type: SnackBarType.warning);
  }

  void _showOrderConfirmedSnackBar(BuildContext context) {
    showSnackBar(
      context,
      '¡Pedido confirmado! Gracias por tu compra.',
      type: SnackBarType.success,
    );
  }
}
