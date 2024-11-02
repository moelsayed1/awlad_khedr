import 'package:awlad_khedr/core/custom_text_field.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return const CustomTextField(
      hintText: 'أبحث عن منتجاتك',
      prefixIcon: Icon(Icons.search),
    );
  }
}
