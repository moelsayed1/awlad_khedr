import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'package:awlad_khedr/features/payment_gateway/presentation/views/widgets/payment_app_bar.dart';
import 'package:awlad_khedr/features/payment_gateway/presentation/views/widgets/payment_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Make sure to import your baseFont and .sp extension if not already imported

class PaymentView extends StatelessWidget {
  final List<Product> products;
  final double total;

  const PaymentView({Key? key, required this.products, required this.total})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PaymentAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تفاصيل الطلب',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                fontFamily: baseFont,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: products.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    title: Text(
                      product.productName ?? '',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: baseFont,
                      ),
                    ),
                    subtitle: Text(
                      'السعر: ${product.price} ج.م',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: baseFont,
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الإجمالي:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: baseFont,
                  ),
                ),
                Text(
                  '${total.toStringAsFixed(2)} ج.م',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: baseFont,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            PaymentForm(),
          ],
        ),
      ),
    );
  }
}


