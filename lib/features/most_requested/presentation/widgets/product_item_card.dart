import 'package:flutter/material.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'package:awlad_khedr/constant.dart';

class ProductItemCard extends StatelessWidget {
  final Product product;
  final int quantity;
  final Function(int) onQuantityChanged;

  const ProductItemCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.productName ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: baseFont,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'السعــر: ${product.price} ج.م',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.orange[700],
                  fontFamily: baseFont,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الكمية: $quantity',
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: baseFont,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, color: Colors.orange[700]),
                          onPressed: quantity > 0
                              ? () => onQuantityChanged(quantity - 1)
                              : null,
                        ),
                        Text(
                          '$quantity',
                          style: TextStyle(
                            color: Colors.orange[700],
                            fontWeight: FontWeight.bold,
                            fontFamily: baseFont,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.orange[700]),
                          onPressed: () => onQuantityChanged(quantity + 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
