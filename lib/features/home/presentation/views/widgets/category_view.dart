// lib/features/categories/presentation/views/categories_page.dart

import 'dart:convert';
import 'dart:math'; // For min function
import 'package:awlad_khedr/features/home/presentation/views/widgets/categories_app_bar.dart';
import 'package:awlad_khedr/features/payment_gateway/presentation/views/payment_view.dart';
import 'package:awlad_khedr/features/products_screen/model/product_by_category_model.dart' hide Product;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:awlad_khedr/core/theme/app_colors.dart';

// Make sure these imports are correct based on your project structure
import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/main.dart'; // Assuming authToken comes from here
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'package:awlad_khedr/features/drawer_slider/presentation/views/side_slider.dart'; // Assuming CustomDrawer
import 'package:awlad_khedr/features/home/presentation/views/widgets/search_widget.dart'; // Assuming SearchWidget
import 'package:awlad_khedr/features/most_requested/presentation/widgets/category_filter_bar.dart';
import 'package:awlad_khedr/features/most_requested/presentation/widgets/product_item_card.dart'; // Assuming ProductItemCard

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  TopRatedModel? topRatedItem; // Holds all products loaded from GetAllProducts
  bool isListLoaded = false;
  ProductByCategoryModel? productByCategory; // This model might not be strictly needed if Product is versatile
  List<String> _categories = ['الكل']; // Initialize with 'الكل' only
  String _selectedCategory = 'الكل';
  final Map<String, int> _productQuantities = {};
  final Map<Product, int> _cart = {};
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = []; // This list is what's displayed

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _initializeData(); // Start the data loading process
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // This method will handle initial data fetching for categories and products
  Future<void> _initializeData() async {
    setState(() {
      isListLoaded = false; // Show loading indicator
    });

    try {
      // 1. Fetch categories for the filter bar
      await _fetchCategories();

      // 2. Based on initial _selectedCategory ('الكل'), fetch relevant products
      if (_selectedCategory == 'الكل') {
        await GetAllProducts(); // Load all products initially
      } else {
        await GetProductByCategory(); // Load products for a specific initial category (if not 'الكل')
      }

      // 3. Apply any initial search filter if _searchController has text
      _applySearchFilter();

    } catch (e) {
      print('Error initializing data: $e');
      // Potentially show an error message to the user
    } finally {
      if (mounted) {
        setState(() {
          isListLoaded = true; // Hide loading indicator
        });
      }
    }
  }

  // Fetches categories to populate the filter bar
  Future<void> _fetchCategories() async {
    try {
      print('Fetching categories...');
      final response = await http.get(
        Uri.parse('https://erp.khedrsons.com/api/category/products'),
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
        },
      );

      print('Categories API Response Status: ${response.statusCode}');
      // Truncate response body for cleaner console output if it's very long
      print('Categories API Response Body: ${response.body.substring(0, min(response.body.length, 500))}...');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        List<String> fetchedCategories = [];

        // Correctly parse the 'categories' key from the root of the JSON
        if (jsonResponse['categories'] != null && jsonResponse['categories'] is List) {
          for (var categoryJson in jsonResponse['categories']) {
            if (categoryJson['category_name'] != null && (categoryJson['category_name'] as String).isNotEmpty) {
              fetchedCategories.add(categoryJson['category_name'] as String);
            }
          }
          print('Parsed Categories: $fetchedCategories');

          if (mounted) {
            setState(() {
              // Ensure 'الكل' is always the first category and remove duplicates
              _categories = ['الكل', ...fetchedCategories.toSet().toList()];
            });
          }
        } else {
          print('Categories data is not in expected format: `categories` key not found or not a list.');
        }
      } else {
        print('Failed to fetch categories. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error fetching categories: $e');
      print('Stack trace (Categories): $stackTrace');
    }
  }

  double get _cartTotal {
    double total = 0;
    _cart.forEach((product, qty) {
      final price = product.price;
      double priceValue = 0;
      if (price is num) {
        priceValue = (price as num).toDouble();
      } else if (price is String) {
        priceValue = double.tryParse(price) ?? 0;
      }
      total += priceValue * qty;
    });
    return total;
  }

  // Handles changes in the search bar
  void _onSearchChanged() {
    _filterProducts(); // Re-filter products whenever search query changes
  }

  // Central filtering logic based on selected category and search query
  Future<void> _filterProducts() async {
    setState(() {
      isListLoaded = false; // Show loading indicator while filtering
    });

    try {
      if (_selectedCategory == 'الكل') {
        await GetAllProducts(); // Re-fetch all products
      } else {
        await GetProductByCategory(); // Re-fetch products for the selected category
      }

      _applySearchFilter(); // Apply search filter to the newly loaded products

    } catch (e) {
      print('Error in _filterProducts: $e');
    } finally {
      if (mounted) {
        setState(() {
          isListLoaded = true; // Hide loading indicator
        });
      }
    }
  }

  // Applies the search query to the currently loaded products (either all or by category)
  void _applySearchFilter() {
    List<Product> productsToFilter = topRatedItem?.products ?? []; // Use topRatedItem as the base
    final query = _searchController.text.toLowerCase();

    if (query.isNotEmpty) {
      _filteredProducts = productsToFilter.where((product) {
        return (product.productName?.toLowerCase().contains(query) ?? false);
        // Removed categoryName from search filter for cleaner product search if it's not a primary use case.
        // Add it back if category search is also desired in the same bar.
      }).toList();
    } else {
      _filteredProducts = productsToFilter; // If no search query, show all products for the selected category/all
    }
    // No setState here, as it's typically called by the caller (_filterProducts or _initializeData)
  }


  // Fetches all products
  Future<void> GetAllProducts() async {
    print('Fetching all products...');
    Uri uriToSend = Uri.parse(APIConstant.GET_ALL_PRODUCTS);
    try {
      final response = await http.get(
        uriToSend,
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
          "Content-Type": "application/json", // Still include, as some APIs prefer it even for GET
        },
      );

      print('Products API Response Status: ${response.statusCode}');
      print('Products API Response Body (GetAllProducts): ${response.body.substring(0, min(response.body.length, 500))}...');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        List<Product> products = [];

        if (jsonResponse is Map<String, dynamic>) {
          if (jsonResponse['products'] != null && jsonResponse['products'] is List) {
            products = (jsonResponse['products'] as List)
                .map((productJson) => Product.fromJson(productJson as Map<String, dynamic>))
                .toList();
          } else if (jsonResponse['data'] != null &&
              jsonResponse['data'] is Map<String, dynamic> &&
              jsonResponse['data']['products'] is List) {
            products = (jsonResponse['data']['products'] as List)
                .map((productJson) => Product.fromJson(productJson as Map<String, dynamic>))
                .toList();
          }
        } else if (jsonResponse is List) {
          products = jsonResponse
              .map((productJson) => Product.fromJson(productJson as Map<String, dynamic>))
              .toList();
        }

        print('Parsed Products Count (GetAllProducts): ${products.length}');

        if (!mounted) return;

        setState(() {
          topRatedItem = TopRatedModel(products: products); // Update the base list
          // Don't directly set _filteredProducts here; _applySearchFilter will do it.
        });

        // Re-initialize product quantities for the new set of products
        _productQuantities.clear();
        for (var product in products) { // Iterate over the newly fetched products
          _productQuantities[product.productName!] = 0;
        }

      } else {
        print('Failed to load all products. Status code: ${response.statusCode}');
        if (mounted) {
          setState(() {
            topRatedItem = TopRatedModel(products: []); // Clear products on failure
          });
        }
      }
    } catch (e, stackTrace) {
      print('Error fetching all products: $e');
      print('Stack trace (GetAllProducts): $stackTrace');
      if (mounted) {
        setState(() {
          topRatedItem = TopRatedModel(products: []); // Clear products on error
        });
      }
    }
  }

  // Fetches products for a specific category
  Future<void> GetProductByCategory() async {
    print('Fetching products for category: $_selectedCategory');
    Uri uriToSend = Uri.parse('https://erp.khedrsons.com/api/category/products').replace(
      queryParameters: {
        'category_name': _selectedCategory, // Parameter name as expected by your API
      },
    );

    try {
      final response = await http.get( // Use GET method
        uriToSend,
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
        },
      );

      print('Category Products API Response Status: ${response.statusCode}');
      print('Category Products API Response Body: ${response.body.substring(0, min(response.body.length, 500))}...');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        List<Product> productsForCategory = [];

        // Parse the response structure for category products
        // It seems the API returns a list of categories, and you need to find the one matching _selectedCategory
        if (jsonResponse['categories'] is List) {
          for (var categoryEntry in jsonResponse['categories']) {
            if (categoryEntry['category_name'] == _selectedCategory) {
              // Extract products directly under the matching category
              if (categoryEntry['products'] is List) {
                productsForCategory.addAll(
                  (categoryEntry['products'] as List)
                      .map((p) => Product.fromJson(p as Map<String, dynamic>))
                      .toList(),
                );
              }
              // Extract products from sub_categories if present
              if (categoryEntry['sub_categories'] is List) {
                for (var subCategoryEntry in categoryEntry['sub_categories']) {
                  if (subCategoryEntry['products'] is List) {
                    productsForCategory.addAll(
                      (subCategoryEntry['products'] as List)
                          .map((p) => Product.fromJson(p as Map<String, dynamic>))
                          .toList(),
                    );
                  }
                }
              }
              break; // Found the category, no need to check others
            }
          }
        }
        print('Parsed Products Count for $_selectedCategory: ${productsForCategory.length}');

        if (mounted) {
          setState(() {
            topRatedItem = TopRatedModel(products: productsForCategory); // Update the base list
            // Don't directly set _filteredProducts here; _applySearchFilter will do it.
          });

          // Re-initialize quantities for new products
          _productQuantities.clear();
          for (var product in productsForCategory) {
            _productQuantities[product.productName!] = 0;
          }
        }
      } else {
        print('Failed to load category products. Status code: ${response.statusCode}');
        if (mounted) {
          setState(() {
            topRatedItem = TopRatedModel(products: []); // Clear products on failure
          });
        }
      }
    } catch (e, stackTrace) {
      print('Error fetching category products: $e');
      print('Stack trace (GetProductByCategory): $stackTrace');
      if (mounted) {
        setState(() {
          topRatedItem = TopRatedModel(products: []); // Clear products on error
        });
      }
    }
  }


  void _onQuantityChanged(String productId, int newQuantity) {
    setState(() {
      _productQuantities[productId] = newQuantity;
    });
  }

  Widget _buildCartSheet(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'السلة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp, // Adjusted font size for title
                fontWeight: FontWeight.bold,
                fontFamily: baseFont,
              ),
            ),
            SizedBox(height: 10.h),
            if (_cart.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Text(
                  'السلة فارغة',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                    fontFamily: baseFont,
                  ),
                ),
              ),
            ..._cart.entries.map((entry) {
              final product = entry.key;
              final quantity = entry.value;
              final price = product.price;
              double priceValue = 0;
              if (price is num) {
                priceValue = (price as num).toDouble();
              } else if (price is String) {
                priceValue = double.tryParse(price) ?? 0;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.productName ?? 'Unknown Product',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontFamily: baseFont,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'الكمية: $quantity',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: baseFont,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      '${(priceValue * quantity).toStringAsFixed(2)} ج.م',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: baseFont,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const Divider(color: Colors.white54),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الإجمالي:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: baseFont,
                    ),
                  ),
                  Text(
                    '${_cartTotal.toStringAsFixed(2)} ج.م',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: baseFont,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity, // Make button fill width
              child: ElevatedButton(
                onPressed: _cart.isNotEmpty
                    ? () {
                  Navigator.pop(context); // Close the bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentView(
                          products: _cart.keys.toList(), total: _cartTotal),
                    ),
                  );
                }
                    : null, // Disable button if cart is empty
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'الدفع',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: baseFont,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CategoriesAppBar(),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SearchWidget(controller: _searchController),
                const SizedBox(height: 15),
                SizedBox(
                  height: 50, // Fixed height for category bar
                  child: CategoryFilterBar(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (category) {
                      setState(() {
                        _selectedCategory = category;
                        _searchController.clear(); // Clear search when category changes
                      });
                      _filterProducts(); // Re-filter based on the new category
                    },
                  ),
                ),
                const SizedBox(height: 15),
                if (!isListLoaded)
                  const Center(child: CircularProgressIndicator())
                else if (_filteredProducts.isEmpty)
                  Center(
                    child: Text(
                      'لا توجد منتجات متاحة لهذه الفئة.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.sp,
                        fontFamily: baseFont,
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    itemCount: _filteredProducts.length,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const SizedBox(height: 15),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return Column(
                        children: [
                          ProductItemCard(
                            product: product,
                            quantity: _productQuantities[product.productName!] ?? 0,
                            onQuantityChanged: (newQuantity) {
                              _onQuantityChanged(product.productName!, newQuantity);
                            },
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _cart[product] = (_cart[product] ?? 0) + 1;
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
                          ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _cart.isNotEmpty
          ? FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.25,
              maxChildSize: 0.75,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: _buildCartSheet(context),
                );
              },
            ),
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
        icon: const Icon(Icons.shopping_cart, color: Colors.white),
      )
          : null,
    );
  }
}