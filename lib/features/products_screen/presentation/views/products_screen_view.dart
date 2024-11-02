import 'package:awlad_khedr/features/home/presentation/views/widgets/search_widget.dart';
import 'package:awlad_khedr/features/products_screen/presentation/views/widgets/products.dart';
import 'package:flutter/material.dart';

import '../../../../constant.dart';
import '../../../../core/assets.dart';
import '../../../drawer_slider/presentation/views/side_slider.dart';

class ProductsScreenView extends StatelessWidget {
  const ProductsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'المنتجاتً',
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
        body:const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SearchWidget(),
                SizedBox(height: 15,),
                ProductItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
