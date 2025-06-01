import 'dart:convert';
import 'dart:math';

import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'package:awlad_khedr/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../drawer_slider/presentation/views/side_slider.dart';
import '../../../home/presentation/views/widgets/search_widget.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/most_requested_app_bar.dart';
import '../widgets/product_item_card.dart';

class MostRequestedPage extends StatefulWidget {
  const MostRequestedPage({super.key});

  @override
  State<MostRequestedPage> createState() => _MostRequestedPageState();
}

class _MostRequestedPageState extends State<MostRequestedPage> {
  TopRatedModel? topRatedItem;
  bool isListLoaded = false;

  final Map<String, int> _productQuantities = {}; // Key: product ID or unique identifier, Value: quantity

  final List<String> _categories = [
    'الكل',
    'المشروبات',
    'منتجات البان',
    'حلويات',
    // Add more categories as needed
  ];
  String _selectedCategory = 'الكل'; // Initial selected category

  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    GetTopRatedItems();
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

    // Filter by category
    if (_selectedCategory != 'الكل') {
      tempProducts = tempProducts.where((p) {
        // Now, 'p.categoryName' should exist.
        // Convert both to lowercase for case-insensitive comparison.
        return p.categoryName != null && p.categoryName!.toLowerCase() == _selectedCategory.toLowerCase();
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
    Uri uriToSend = Uri.parse(APIConstant.GET_TOP_RATED_ITEMS);
    try {
      final response = await http.get(uriToSend, headers: {"Authorization" : "Bearer $authToken"});
      if (response.statusCode == 200) {
        topRatedItem = TopRatedModel.fromJson(jsonDecode(response.body));
        // Initialize quantities for each product to 0 using a unique identifier (e.g., product name or ID)
        if (topRatedItem != null && topRatedItem!.products.isNotEmpty) {
          for (var product in topRatedItem!.products) {
            _productQuantities[product.productName!] = 0; // Using product name as key for simplicity
          }
        }
        _filterProducts(); // Apply initial filters (if any)
      } else {
        print('Failed to load top rated items: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching top rated items: $e');
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
      appBar: const MostRequestedAppBar(),
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
                // MODIFIED LINE HERE: Limit itemCount to a maximum of 10
                itemCount: min(_filteredProducts.length, 10),
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 15),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                reverse: false,
                itemBuilder: (BuildContext context, int index) {
                  final product = _filteredProducts[index];
                  return ProductItemCard(
                    product: product,
                    quantity: _productQuantities[product.productName!] ?? 0,
                    onQuantityChanged: (newQuantity) {
                      _onQuantityChanged(product.productName!, newQuantity);
                    },
                  );
                },
              )
                  : const Center(child: Text('No products available for the current filter.')))
                  : const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Modified SearchWidget (if you want to make it reusable with a controller) ---
// You might need to adjust your existing SearchWidget or create a new one.

// Assuming your original SearchWidget looked something like this:
/*
class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'ابحث عن منتجاتك',
          border: InputBorder.none,
          icon: Icon(Icons.search),
        ),
      ),
    );
  }
}
*/