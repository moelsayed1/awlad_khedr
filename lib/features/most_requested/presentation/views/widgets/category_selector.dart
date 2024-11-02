import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';

class CustomCategorySelector extends StatefulWidget {
  const CustomCategorySelector({super.key});

  @override
  _CustomCategorySelectorState createState() => _CustomCategorySelectorState();
}

class _CustomCategorySelectorState extends State<CustomCategorySelector> {

  int selectedIndex = 0;

  // Tab titles
  final List<String> tabs = ['الكل', 'المشروبات', 'منتجات البان', 'حلويات', 'مستلزمات'];

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: double.infinity,
      height: 36,
      child: ListView.builder(
          shrinkWrap: true,
          reverse: true,
          scrollDirection: Axis.horizontal,
          itemCount: tabs.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                // margin: const EdgeInsets.symmetric(horizontal: 8.0),
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? darkOrange // Active tab background
                      : Colors.white, // Inactive tab background
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: selectedIndex == index
                        ? Colors.white // Active tab text color
                        : Colors.black, // Inactive tab text color
                    fontWeight: FontWeight.bold,
                    fontFamily: baseFont,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }),

    );
  }
}