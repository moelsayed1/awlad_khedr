import 'package:awlad_khedr/core/main_layout.dart';
import 'package:awlad_khedr/features/cart/presentation/views/widgets/cart_item.dart';
import 'package:awlad_khedr/features/cart/presentation/views/widgets/custom_button_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constant.dart';
import '../../../../core/assets.dart';
import '../../../drawer_slider/presentation/views/side_slider.dart';
class CartViewPage extends StatefulWidget {

   const CartViewPage({super.key , });


  @override
  State<CartViewPage> createState() => _CartViewPageState();
}
class _CartViewPageState extends State<CartViewPage> {
  @override
  Widget build(BuildContext context) {
    double count = 3000;

    return MainLayout(
      selectedIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'الاوردر',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: baseFont),
              ),
            )
          ],
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Builder(
              builder: (context) => IconButton(
                icon: Image.asset(
                  AssetsData.drawerIcon,
                  height: 45,
                  width: 45,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          centerTitle: true,
          titleSpacing: 0,
        ),
        drawer: const CustomDrawer(),
        body: Column(
          children: [
            Padding(
              padding:  EdgeInsets.all(16.0.r),
              child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * .55,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                    child: CartItem(),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height * .213,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      color: Colors.black,
                      offset: Offset(0, 2),
                    ),
                  ],
                  color: Colors.white,
                ),
                child:  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'الحد الادني الاوردر 3000 جنيه لاستكمال الطلب',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: baseFont,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20,),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'EGP ${count.toInt()}',
                            style:const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                         const Text('الاجمالي',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontFamily: baseFont)),
                        ],
                      ),
                      const Spacer(),
                      CustomButtonCart(count: count,),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
