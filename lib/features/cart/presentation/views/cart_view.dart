import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/main_layout.dart';
import 'package:awlad_khedr/features/cart/presentation/views/widgets/cart_item.dart';
import 'package:awlad_khedr/features/cart/presentation/views/widgets/custom_button_cart.dart';
import 'package:awlad_khedr/features/products_screen/model/product_by_category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/features/drawer_slider/presentation/views/side_slider.dart';

class CartViewPage extends StatefulWidget {
  const CartViewPage({super.key});

  @override
  State<CartViewPage> createState() => _CartViewPageState();
}

class _CartViewPageState extends State<CartViewPage> {
  // Example products, replace with your real data source
  // In CartViewPage, update your example products like this:
  final List<Product> products = [
    Product(productId: 1, productName: 'بيبسي زيرو 1 لتر', productPrice: '100', qtyAvailable: 10, minimumSoldQuantity: 6, image: null, imageUrl: 'https://vivendadocamarao.vtexassets.com/arquivos/ids/158341/PEPSI-ZERO-LATA-350ML.jpg?v=638055201699200000'), // Replace with a real URL
    Product(productId: 2, productName: 'كوكا كولا علب', productPrice: '80', qtyAvailable: 10, minimumSoldQuantity: 24, image: null, imageUrl: 'https://images.deliveryhero.io/image/talabat-nv/Blob_Images/OM1N90PR.jpg'), // Replace with a real URL
    Product(productId: 3, productName: 'فانتا برتقال 2.5 لتر', productPrice: '90', qtyAvailable: 10, minimumSoldQuantity: 4, image: null, imageUrl: 'https://assets.matjrah.store/images/1510/image/cache/catalog/productimage/2284a44d4a82f1dcadc106aef32c00bc7743-1000x1000.jpg'), // Replace with a real URL
    Product(productId: 4, productName: 'سبرايت صغير', productPrice: '85', qtyAvailable: 10, minimumSoldQuantity: 12, image: null, imageUrl: 'https://www.coca-cola.com/content/dam/onexp/xf/ar/product-images/ar_sprite_prod_sprite_750x750.jpg'), // Replace with a real URL
  ];

  late List<int> _quantities;
  double _total = 0;

  @override
  void initState() {
    super.initState();
    _quantities = List<int>.filled(products.length, 1);
    _calculateTotal();
  }

  void _onQuantityChanged(int index, int newQuantity) {
    setState(() {
      _quantities[index] = newQuantity;
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    _total = 0;
    for (int i = 0; i < products.length; i++) {
      final price = double.tryParse(products[i].productPrice ?? '0') ?? 0;
      _total += price * _quantities[i];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 1,
      child: Scaffold(
        backgroundColor: Colors.grey[50], // Light background to match image
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
                  fontFamily: baseFont,
                ),
                textDirection: TextDirection.rtl, // Right-to-left for Arabic
              ),
            ),
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0.r),
                // This is the ListView that iterates and creates individual CartItem widgets
                child: ListView.separated(
                  itemCount: products.length,
                  separatorBuilder: (context, index) => SizedBox(height: 15.h),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final quantity = _quantities[index];
                    return CartItem(
                      product: product, // Pass single product
                      quantity: quantity, // Pass single quantity
                      index: index, // Pass the index
                      onQuantityChanged: _onQuantityChanged,
                    );
                  },
                ),
              ),
            ),
            // Bottom Total Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.with(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'الحد الادني الاوردر 3000 جنيه لاستكمال الطلب',
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: baseFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'EGP ${_total.toInt()}',
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily: baseFont,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      Text(
                        'الاجمالي',
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: baseFont,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  CustomButtonCart(count: _total),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}