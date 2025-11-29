import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop_agence/src/core/theme/app_theme.dart';
import 'package:shop_agence/src/data/data_source/services/product_services.dart';
import 'package:shop_agence/src/presentation/widgets/custom_drawer.dart';
import 'package:shop_agence/src/presentation/widgets/custom_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  final ScrollController _scrollController = ScrollController();

  List products = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        loadProducts();
      }
    });
  }

  Future<void> loadProducts() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    final newProducts = await _productService.getProductsByPage(
      currentPage,
      limit: 10,
    );

    if (newProducts.isEmpty) {
      setState(() => hasMore = false);
    } else {
      setState(() {
        products.addAll(newProducts);
        currentPage++;
      });
    }

    setState(() {
      isLoading = false;
      _isInitialLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Iconsax.menu_1),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: AppTheme.secondaryColor,
              ),
            ),
          ),
        ],
        title: const Text("Home"),
      ),
      drawer: const CustomDrawer(),

      body: Column(
        children: [
          // LISTA DE PRODUCTOS
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.68,
              ),
              itemCount: _isInitialLoading
                  ? 6
                  : products.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                // Mostrar shimmer durante la carga inicial
                if (_isInitialLoading) {
                  return const ProductShimmerCard();
                }
                if (index == products.length) {
                  return const ProductShimmerCard();
                }

                final item = products[index];

                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Image.network(item.image, fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.description,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 8),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${item.price}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.darkTextDisabled.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add_shopping_cart,
                                color: AppTheme.secondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
