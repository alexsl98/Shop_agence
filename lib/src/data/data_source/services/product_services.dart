import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_agence/src/data/models/product_model.dart';

class ProductService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  final http.Client client;

  ProductService({http.Client? client}) : client = client ?? http.Client();

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await client.get(Uri.parse('$_baseUrl/products'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => ProductModel.fromJson(data)).toList();
      } else {
        throw Exception(
          'Ocurrio un error al cargar los productos.',
        );
      }
    } catch (e) {
      throw Exception('Ocurrio un error al cargar los productos. Revise su conexiòn a internet');
    }
  }

  Future<List<ProductModel>> getProductsByPage(
    int page, {
    int limit = 10,
  }) async {
    final allProducts = await getAllProducts();

    final start = (page - 1) * limit;
    final end = start + limit;

    if (start >= allProducts.length) return [];

    return allProducts.sublist(
      start,
      end > allProducts.length ? allProducts.length : end,
    );
  }
  
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await client.get(Uri.parse('$_baseUrl/products/$id'));

      if (response.statusCode == 200) {
        return ProductModel.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        throw Exception(
          'Failed to load product. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  void dispose() {
    client.close();
  }
}
