import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/features/products_screen/presentation/views/widgets/counter_virtecal.dart';
import 'package:flutter/material.dart';
import '../../../../../core/assets.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductItem> {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: 5,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
              height: 15,
            ),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        reverse: false,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                blurRadius: 6,

                                offset: const Offset(0, 3),
                              ),
                            ]),
                        child: Image.asset(
                          AssetsData.logoPng,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Product Information
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "V Cola",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "شرنك = ١ * ٤",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "EGP 100 سعر",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const CounterVertical(),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
