import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/main.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'package:awlad_khedr/features/most_requested/presentation/widgets/product_item_card.dart';

class DairyProductsPage extends StatefulWidget {
  const DairyProductsPage({super.key});

  @override
  State<DairyProductsPage> createState() => _DairyProductsPageState();
}

class _DairyProductsPageState extends State<DairyProductsPage> {
  TopRatedModel? topRatedItem;
  bool isListLoaded = false;
  final Map<String, int> _productQuantities = {};

  @override
  void initState() {
    super.initState();
    _loadDairyProducts();
  }

  Future<void> _loadDairyProducts() async {
    Uri uriToSend = Uri.parse('https://erp.khedrsons.com/api/category/products');
    try {
      final response = await http.post(
        uriToSend,
        headers: {
          "Authorization": "Bearer $authToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "category_name": "منتجات البان",
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          topRatedItem = TopRatedModel.fromJson(jsonDecode(response.body));
          if (topRatedItem != null && topRatedItem!.products.isNotEmpty) {
            for (var product in topRatedItem!.products) {
              _productQuantities[product.productName!] = 0;
            }
          }
        });
      } else {
        print('Failed to load dairy products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching dairy products: $e');
    } finally {
      setState(() {
        isListLoaded = true;
      });
    }
  }

  void _onQuantityChanged(String productId, int newQuantity) {
    setState(() {
      _productQuantities[productId] = newQuantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('منتجات البان'),
        centerTitle: true,
      ),
      body: isListLoaded
          ? (topRatedItem != null && topRatedItem!.products.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: topRatedItem!.products.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final product = topRatedItem!.products[index];
                    return ProductItemCard(
                      product: product,
                      quantity: _productQuantities[product.productName!] ?? 0,
                      onQuantityChanged: (newQuantity) {
                        _onQuantityChanged(product.productName!, newQuantity);
                      },
                    );
                  },
                )
              : const Center(child: Text('لا توجد منتجات البان متاحة')))
          : const Center(child: CircularProgressIndicator()),
    );
  }
} 