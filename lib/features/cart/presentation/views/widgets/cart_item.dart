// import 'package:awlad_khedr/features/products_screen/presentation/model/items_list.dart';
import 'package:flutter/material.dart';

import '../../../../../core/assets.dart';

class CartItem extends StatefulWidget {
  const CartItem({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<CartItem> {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 5,
        // itemCount: groceryItems.length,
        // physics: NeverScrollableScrollPhysics(),
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
                              'as',
                              // groceryItems[index].name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "unites",
                              // "شرنك =${groceryItems[index].quantity}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'price',
                              // "${groceryItems[index].price} سعر ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                       // CounterVertical(index: index,item: groceryItems[index],),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
