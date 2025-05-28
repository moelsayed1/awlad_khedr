// lib/features/categories/presentation/views/categories_page.dart

import 'dart:convert';
import 'dart:math'; // For min function
import 'package:awlad_khedr/features/home/presentation/views/widgets/categories_app_bar.dart';
import 'package:awlad_khedr/features/payment_gateway/presentation/views/payment_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

// Make sure these imports are correct based on your project structure
import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/main.dart'; // Assuming authToken comes from here
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'package:awlad_khedr/features/drawer_slider/presentation/views/side_slider.dart'; // Assuming CustomDrawer
import 'package:awlad_khedr/features/home/presentation/views/widgets/search_widget.dart'; // Assuming SearchWidget
import 'package:awlad_khedr/features/most_requested/presentation/widgets/category_filter_bar.dart';
import 'package:awlad_khedr/features/most_requested/presentation/widgets/product_item_card.dart'; // Assuming ProductItemCard

// You'll need to create this custom app bar below, or just replace it with a standard AppBar

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  TopRatedModel? topRatedItem; // Reusing TopRatedModel for data structure
  bool isListLoaded = false;

  final Map<String, int> _productQuantities = {};

  final Map<Product, int> _cart = {}; // Product as key, quantity as value

  double get _cartTotal {
    double total = 0;
    _cart.forEach((product, qty) {
      final price = product.price;
      double priceValue = 0;
      if (price is num) {
        priceValue = price != null ? (price as num).toDouble() : 0;
      } else if (price is String) {
        priceValue = double.tryParse(price) ?? 0;
      }
      total += priceValue * qty;
    });
    return total;
  }

  final List<String> _categories = [
    'الكل',
    'المشروبات',
    'منتجات البان',
    'حلويات',
    // Add more categories as needed
  ];
  String _selectedCategory = 'الكل';

  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    GetTopRatedItems(); // Keep this for now, it fetches all items
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterProducts();
  }

  void _filterProducts() {
    if (topRatedItem == null || topRatedItem!.products.isEmpty) {
      _filteredProducts = [];
      return;
    }

    List<Product> tempProducts = topRatedItem!.products;

    // Filter by category - IMPORTANT: Your Product model needs a 'category' field for this to work properly.
    // For now, if your Product model doesn't have a category, this filter will not change anything.
    if (_selectedCategory != 'الكل') {
      tempProducts = tempProducts.where((p) {
        // Now, 'p.categoryName' should exist.
        // Convert both to lowercase for case-insensitive comparison.
        return p.categoryName != null &&
            p.categoryName!.toLowerCase() == _selectedCategory.toLowerCase();
      }).toList();
    }

    // --- Search Query Filtering Logic (already correct) ---
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      tempProducts = tempProducts.where((product) {
        return product.productName!.toLowerCase().contains(query);
      }).toList();
    }

    setState(() {
      _filteredProducts = tempProducts;
    });
  }

  GetTopRatedItems() async {
    Uri uriToSend =
        Uri.parse(APIConstant.GET_TOP_RATED_ITEMS); // This fetches "top rated"
    // If you have a different API endpoint for "all categories" products, use it here instead.
    try {
      final response = await http
          .get(uriToSend, headers: {"Authorization": "Bearer $authToken"});
      if (response.statusCode == 200) {
        topRatedItem = TopRatedModel.fromJson(jsonDecode(response.body));
        if (topRatedItem != null && topRatedItem!.products.isNotEmpty) {
          for (var product in topRatedItem!.products) {
            _productQuantities[product.productName!] = 0;
          }
        }
        _filterProducts();
      } else {
        print('Failed to load items: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching items: $e');
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

  Widget _buildCartSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'السلة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              fontFamily: baseFont,
            ),
          ),
          ..._cart.entries.map((entry) => ListTile(
                title: Text(
                  entry.key.productName ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: baseFont,
                  ),
                ),
                subtitle: Text(
                  'الكمية: ${entry.value}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: baseFont,
                  ),
                ),
                trailing: Text(
                  '${entry.key.price ?? 0} ج.م',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: baseFont,
                  ),
                ),
              )),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الإجمالي:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: baseFont,
                  ),
                ),
                Text('${_cartTotal.toStringAsFixed(2)} ج.م'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PaymentView(
                      products: _cart.keys.toList(), total: _cartTotal),
                ),
              );
            },
            child: Text(
              'الدفع',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                fontFamily: baseFont,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- CHANGE APP BAR HERE ---
      // Option 1: Use a custom CategoriesAppBar (recommended for consistency)
      appBar: const CategoriesAppBar(),
      // Option 2: Use a standard AppBar with the title directly
      // appBar: AppBar(
      //   title: const Text(
      //     'الأصنـــاف', // "Categories" in Arabic
      //     style: TextStyle(
      //       color: Colors.black, // Adjust color as needed
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Colors.white, // Adjust color as needed
      //   elevation: 0,
      //   leading: Builder(
      //     builder: (context) => IconButton(
      //       icon: const Icon(Icons.menu, color: Colors.black), // Example menu icon
      //       onPressed: () => Scaffold.of(context).openDrawer(),
      //     ),
      //   ),
      // ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SearchWidget(controller: _searchController),
              const SizedBox(height: 8),
              CategoryFilterBar(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                  _filterProducts();
                },
              ),
              const SizedBox(height: 15),
              isListLoaded
                  ? (topRatedItem != null && _filteredProducts.isNotEmpty
                      ? ListView.separated(
                          itemCount: min(_filteredProducts.length, 10),
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 15),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          reverse: false,
                          itemBuilder: (BuildContext context, int index) {
                            final product = _filteredProducts[index];
                            return Column(
                              children: [
                                ProductItemCard(
                                  product: product,
                                  quantity: _productQuantities[
                                          product.productName!] ??
                                      0,
                                  onQuantityChanged: (newQuantity) {
                                    _onQuantityChanged(
                                        product.productName!, newQuantity);
                                  },
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 8.h),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _cart[product] =
                                          (_cart[product] ?? 0) + 1;
                                    });
                                  },
                                  child: Text(
                                    'إضافة إلى السلة',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: baseFont,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                              'No products available for the current filter.')))
                  : const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
      floatingActionButton: _cart.isNotEmpty
          ? FloatingActionButton.extended(
              backgroundColor: Colors.orange,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => _buildCartSheet(context),
                );
              },
              label: Text(
                'السلة (${_cart.length})',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: baseFont,
                ),
              ),
              icon: const Icon(Icons.shopping_cart),
            )
          : null,
    );
  }
}

// --- Create CategoriesAppBar (optional, but good for consistency) ---
// You can put this in a new file like 'lib/features/categories/presentation/widgets/categories_app_bar.dart'
// or directly in this file if it's small.
