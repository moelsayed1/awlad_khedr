import 'package:flutter/material.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'package:awlad_khedr/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductItemCard extends StatelessWidget {
  final Product product;
  final int quantity;
  final Function(int) onQuantityChanged;
  final VoidCallback? onAddToCart;

  const ProductItemCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
    this.onAddToCart,
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
        height: 220.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Details (Left Side)
                    Expanded(
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
                              fontSize: 18.sp,
                              color: Colors.orange[700],
                              fontFamily: baseFont,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                         SizedBox(height: 8.h),
                          Text(
                            'الكمية: $quantity',
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black87,
                              fontFamily: baseFont,
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Product Image (Right Side)
                    Column(
                      children: [
                        Container(
                          width: 100.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.withOpacity(0.2)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: (product.imageUrl != null && product.imageUrl!.isNotEmpty && product.imageUrl! != 'https://erp.khedrsons.com/uploads/img/1745829725_%D9%81%D8%B1%D9%8A%D9%85.png')
                                ? Image.network(
                                    product.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset('assets/images/logoPng.png', fit: BoxFit.contain);
                                    },
                                  )
                                : Image.asset('assets/images/logoPng.png', fit: BoxFit.contain),
                          ),
                        ),
                       SizedBox(height: 16.h),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove, color: Colors.orange[700], size: 20),
                                onPressed: () => onQuantityChanged(quantity > 0 ? quantity - 1 : 0),
                                padding: const EdgeInsets.all(4),
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
                                icon: Icon(Icons.add, color: Colors.orange[700], size: 20),
                                onPressed: () => onQuantityChanged(quantity + 1),
                                padding: const EdgeInsets.all(4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
               SizedBox(height: 8.h),
              // Add to Cart Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onAddToCart,
                  child: const Text(
                    'إضافة إلى السلة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: baseFont,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
