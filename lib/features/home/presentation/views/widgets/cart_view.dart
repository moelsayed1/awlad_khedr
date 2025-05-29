import 'package:awlad_khedr/features/home/presentation/views/widgets/cart_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';

class CartPage extends StatelessWidget {
  final List<Product> cartProducts;

  const CartPage({super.key, required this.cartProducts});

  double getTotalPrice() {
    double total = 0;
    for (final product in cartProducts) {
      // Try to parse price as double, fallback to 0 if null or invalid
      final price = double.tryParse(product.price?.toString() ?? '') ?? 0;
      total += price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = getTotalPrice();

    return Scaffold(
      appBar: CartAppBar(),
      body: cartProducts.isEmpty
          ? const Center(child: Text('السلة فارغة'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cartProducts.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final product = cartProducts[index];
                      return ListTile(
                        leading: product.image != null && product.image!.isNotEmpty
                            ? Image.network(product.image!, width: 60, height: 60, fit: BoxFit.cover)
                            : const Icon(Icons.image_not_supported),
                        title: Text(product.productName ?? ''),
                        subtitle: Text(product.categoryName ?? ''),
                        trailing: Text('${product.price ?? ''} ج.م'),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'الإجمالي:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${totalPrice.toStringAsFixed(2)} ج.م',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}