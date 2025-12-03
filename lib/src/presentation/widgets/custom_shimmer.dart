import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductShimmerCard extends StatelessWidget {
  const ProductShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Título
            Container(
              height: 12,
              width: double.infinity,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 10),

            // Imagen fantasma
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 10),

            // Descripción simulada
            Container(
              height: 8,
              width: double.infinity,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 6),
            Container(height: 8, width: 80, color: Colors.grey.shade400),

            const SizedBox(height: 10),

            // Precio + botón
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(height: 12, width: 40, color: Colors.grey.shade400),
                Container(height: 24, width: 24, color: Colors.grey.shade400),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
