import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../../core/assets.dart';

class CarouselWithIndicator extends StatefulWidget {
  const CarouselWithIndicator({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
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
            child: Container(
              width: double.infinity,
              height: 160,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
              ),
              child: CarouselSlider(
                items: [
                  Image.asset(AssetsData.carousel,fit: BoxFit.contain,),
                  Image.asset(AssetsData.carousel , fit: BoxFit.contain,),
                  Image.asset(AssetsData.carousel , fit: BoxFit.contain),
                  Image.asset(AssetsData.carousel, fit: BoxFit.contain),
                  Image.asset(AssetsData.carousel, fit: BoxFit.contain),
                ],
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
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
               GestureDetector(
                // onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 22.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
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