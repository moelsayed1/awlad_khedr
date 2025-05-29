import 'package:flutter/material.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';

class CartPage extends StatelessWidget {
  final List<Product> cartProducts;

  const CartPage({super.key, required this.cartProducts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة المشتريات'),
      ),
      body: cartProducts.isEmpty
          ? const Center(child: Text('السلة فارغة'))
          : ListView.separated(
              itemCount: cartProducts.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final product = cartProducts[index];
                return ListTile(
                  leading: (product.image != null && product.image!.isNotEmpty)
                      ? Image.network(
                          product.image!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 40),
                        )
                      : const Icon(Icons.image_not_supported, size: 40),
                  title: Text(product.productName ?? 'بدون اسم'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.categoryName != null)
                        Text('القسم: ${product.categoryName!}'),
                      if (product.price != null)
                        Text('السعر: ${product.price!} ج.م'),
                    ],
                  ),
                  isThreeLine: true,
                );
              },
            ),
    );
  }
}