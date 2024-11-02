import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/features/order/presentation/views/widgets/custom_rating.dart';
import 'package:awlad_khedr/features/order/presentation/views/widgets/popup_order_reciept.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/assets.dart';

class OrdersViewPage extends StatelessWidget {
  const OrdersViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            GoRouter.of(context).pop();
          },
          child: Row(
            children: [
              Image.asset(
                AssetsData.back,
                color: Colors.black,
              ),
              const Text(
                'للخلف',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: baseFont,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        leadingWidth: 100,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'الطلبات',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: baseFont),
            ),
          )
        ],
      ),
      body: const OrdersList(),
    );
  }
}

class OrdersList extends StatelessWidget {
  const OrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3, // Number of orders
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        return const OrderCard();
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            height: 38,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.black,
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  'الخميس، 17 أكتوبر',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'مطلوب دفعة',
                          style: TextStyle(
                              color: kBrown,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              fontFamily: baseFont),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '3000 ج.م',
                          style: TextStyle(
                            color: kBrown,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: 116,
                            height: 30,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.black),
                            child: const Center(
                              child: Text(
                                'عرض المنتجات',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: baseFont,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          '#553322 رقم الطلب',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'جاري الاستلام',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontFamily: baseFont),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'عربة 1',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: baseFont),
                            ),
                            const SizedBox(width: 4),
                            Image.asset(AssetsData.cycle),
                          ],
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'تقييمك',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: baseFont),
                            ),
                            CustomRating(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: CustomButtonReceipt()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
