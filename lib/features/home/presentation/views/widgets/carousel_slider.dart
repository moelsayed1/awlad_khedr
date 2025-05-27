import 'dart:convert';
import 'package:awlad_khedr/features/home/data/model/carousel_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../constant.dart';
import '../../../../../main.dart';

class CarouselWithIndicator extends StatefulWidget {
  const CarouselWithIndicator({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  BannersModel? bannersItem;
  List<String> imageUrls = [];
  bool isBannerLoaded = false;

  GetAllBanners() async {
    Uri uriToSend = Uri.parse(APIConstant.GET_BANNERS);
    final response = await http.get(uriToSend , headers: {"Authorization" : "Bearer $authToken"});
    if (response.statusCode == 200) {
      bannersItem= BannersModel.fromJson(jsonDecode(response.body));
      print('aaaaaaaaaaaaaaaaaaaaaaa${response.body.toString()}');

    }
    // if (bannersItem!.message!.isEmpty && bannersItem!.message!.isNotEmpty) {
      setState(() {
        isBannerLoaded = true;
      });
    // }
  }
  @override
  void initState() {
    GetAllBanners();
    super.initState();
  }

  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {

    return Column(
        children: [
          InkWell(
            onTap: (){
              // GoRouter.of(context).push(AppRouter.kProductCarouselView);
            },
            child:
            isBannerLoaded ? Container(
              width: double.infinity,
              height: 160,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
              ),
              child: CarouselSlider(
                items: bannersItem!.data.map((item) {
                      return Image.network(
                          bannersItem!.data[_current].imageUrl!,
                          fit: BoxFit.contain,
                  );
                }).toList(),
                carouselController: _controller,
                options: CarouselOptions(
                    height: 240,
                    viewportFraction: 1,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    autoPlayCurve: Curves.easeOutSine,
                    aspectRatio: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
            )
                :const Center(child: CircularProgressIndicator(),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
               GestureDetector(
                // onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 22.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(12))
                  ),
                ),
              )
            ]),
        ]);
  }
}