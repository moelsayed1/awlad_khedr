import 'package:awlad_khedr/features/home/presentation/views/widgets/search_widget.dart';
import 'package:awlad_khedr/features/most_requested/presentation/views/widgets/category_selector.dart';
import 'package:awlad_khedr/features/products_screen/presentation/views/widgets/counter_virtecal.dart';
import 'package:flutter/material.dart';

import '../../../../../core/assets.dart';
import '../../../../constant.dart';
import '../../../drawer_slider/presentation/views/side_slider.dart';

class MostRequestedPage extends StatelessWidget {
  const MostRequestedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Text(
                  'اكثر طلباً',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: baseFont),
                ),
              ],
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SearchWidget(),
              const SizedBox(
                height: 8,
              ),
             const CustomCategorySelector(),
              const SizedBox(
                height: 15,
              ),
              ListView.separated(
                  itemCount: 7,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
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
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
