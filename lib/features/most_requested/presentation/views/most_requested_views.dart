import 'dart:convert';

import 'package:awlad_khedr/features/home/presentation/views/widgets/search_widget.dart';
// import 'package:awlad_khedr/features/products_screen/presentation/model/items_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart'as http ;
import '../../../../../core/assets.dart';
import '../../../../constant.dart';
import '../../../../core/app_router.dart';
import '../../../../main.dart';
import '../../../drawer_slider/presentation/views/side_slider.dart';
import '../../data/model/top_rated_model.dart';

class MostRequestedPage extends StatefulWidget {
  const MostRequestedPage({super.key});

  @override
  State<MostRequestedPage> createState() => _MostRequestedPageState();
}

class _MostRequestedPageState extends State<MostRequestedPage> {
  TopRatedModel? topRatedItem;
  bool isListLoaded = false;
  GetTopRatedItems() async {
    Uri uriToSend = Uri.parse(APIConstant.GET_TOP_RATED_ITEMS);
    final response = await http.get(uriToSend, headers: {"Authorization" : "Bearer $authToken"});
    if (response.statusCode == 200) {
      topRatedItem = TopRatedModel.fromJson(jsonDecode(response.body));
    }
    // if (products!.errors!.isEmpty && products!.data!.isNotEmpty) {
    setState(() {
      isListLoaded = true;
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    GetTopRatedItems();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions:  [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                InkWell(
                  child: const Text(
                    'اكثر طلباً',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: baseFont),
                  ),
                  onTap: (){
                    GoRouter.of(context).push(AppRouter.kHomeScreen);
                  },
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
            builder: (context) => Row(
              children: [
                IconButton(
                  icon: Image.asset(
                    AssetsData.back,
                    height: 45,
                    width: 45,
                  ),
                  onPressed: () {GoRouter.of(context).pop();},
                ),
                 const Text('للرجوع' , style: TextStyle(color: Colors.black,fontSize: 20 , fontFamily: baseFont, fontWeight: FontWeight.w600),),
              ],
            ),
          ),
        ),
leadingWidth: 130,
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
              const SizedBox(
                height: 15,
              ),
              isListLoaded ?
              ListView.separated(
                itemCount: topRatedItem!.products.length,
                  // itemCount: groceryItems.length,
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
                                  child:topRatedItem!.products[index].imageUrl != null
                                      ? Image.network(
                                    topRatedItem!.products[index].imageUrl!,
                                    fit: BoxFit.cover,
                                  )
                                      : Image.asset( 'assets/images/noData.gif',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                 Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        topRatedItem!.products[index].productName!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        topRatedItem!.products[index].minimumSoldQuantity!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        topRatedItem!.products[index].price!,
                                        // "EGP 100 سعر",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                 // CounterVertical(item: groceryItems[index],index: index,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  })
                  :const Center(child: CircularProgressIndicator(),),
            ],
          ),
        ),
      ),
    );
  }
}
