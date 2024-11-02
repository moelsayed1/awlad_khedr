import 'package:awlad_khedr/core/assets.dart';
import 'package:flutter/material.dart';

import '../../../../../constant.dart';

class TopRatedItem extends StatefulWidget {
  TopRatedItem({super.key, required this.name, required this.rating});

  String name;
  String rating;

  @override
  State<TopRatedItem> createState() => _TopRatedItemState();
}

class _TopRatedItemState extends State<TopRatedItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: ListView.separated(
        itemCount: 5,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          width: 15,
        ),
        shrinkWrap: false,
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: 156,
              height: 193,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * .15,
                    color: Colors.transparent,
                    child: Image.asset(
                      AssetsData.carousel,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        widget.rating,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Spacer(),
                      Text(
                        widget.name,
                        style: const TextStyle(color: Colors.black, fontSize: 14 , fontWeight: FontWeight.bold,fontFamily: baseFont),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
