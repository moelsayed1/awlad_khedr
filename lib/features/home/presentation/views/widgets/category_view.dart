import 'dart:convert';
import 'dart:math'; // For min function
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// Ensure all necessary imports are correct and available in your project
import 'package:awlad_khedr/constant.dart'; // For APIConstant, baseFont
import 'package:awlad_khedr/main.dart'; // Assuming authToken comes from here
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart'; // Contains TopRatedModel and Product
import 'package:awlad_khedr/features/drawer_slider/presentation/views/side_slider.dart'; // For CustomDrawer
import 'package:awlad_khedr/features/home/presentation/views/widgets/search_widget.dart'; // For SearchWidget
import 'package:awlad_khedr/features/most_requested/presentation/widgets/category_filter_bar.dart';
import 'package:awlad_khedr/features/most_requested/presentation/widgets/product_item_card.dart'; // For ProductItemCard
import 'package:awlad_khedr/features/home/presentation/views/widgets/categories_app_bar.dart'; // For CategoriesAppBar
import 'package:awlad_khedr/features/payment_gateway/presentation/views/payment_view.dart';
import 'package:awlad_khedr/core/theme/app_colors.dart'; // For AppColors.primary
import 'package:awlad_khedr/features/home/data/repositories/category_repository.dart';
import 'package:awlad_khedr/features/home/presentation/controllers/category_controller.dart';
import 'package:awlad_khedr/features/home/presentation/widgets/cart_sheet.dart';

// Add this to your APIConstant class in constant.dart
// class APIConstant {
//   static const String BASE_URL = 'https://erp.khedrsons.com/api/';
//   static const String GET_ALL_PRODUCTS = BASE_URL + 'products';
//   static const String GET_CATEGORY_PRODUCTS = BASE_URL + 'category/products';
//   // ... other API constants
// }

// Ensure your Product model has a productId field if you want to use it as a key
// (e.g., in top_rated_model.dart, if your API response includes 'product_id')
// class Product {
//   final int? productId; // Add this field
//   final String? productName;
//   final dynamic price; // Can be num or String
//   final dynamic qtyAvailable;
//   final String? minimumSoldQuantity;
//   final String? image;
//   final String? imageUrl;
//   final String? categoryName; // Added for completeness if needed in filtering

//   Product({
//     this.productId, // Initialize it
//     this.productName,
//     this.price,
//     this.qtyAvailable,
//     this.minimumSoldQuantity,
//     this.image,
//     this.imageUrl,
//     this.categoryName,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       productId: json['product_id'] as int?,
//       productName: json['product_name'] as String?,
//       price: json['price'], // Keep dynamic for flexibility
//       qtyAvailable: json['qty_available'],
//       minimumSoldQuantity: json['minimum_sold_quantity'] as String?,
//       image: json['image'] as String?,
//       imageUrl: json['image_url'] as String?,
//       categoryName: json['category_name'] as String?, // Parse if available
//     );
//   }
// }

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CategoryController(CategoryRepository())..initializeData(),
      child: const _CategoriesView(),
    );
  }
}

class _CategoriesView extends StatelessWidget {
  const _CategoriesView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CategoryController>();
    final searchController = TextEditingController();

    return Scaffold(
      appBar: const CategoriesAppBar(),
      drawer: const CustomDrawer(),
      body: SafeArea(
        // REMOVE SingleChildScrollView here
        child: Column( // Use Column instead of SingleChildScrollView here
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchWidget(
                controller: searchController,
                onChanged: controller.applySearchFilter,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SizedBox(
                height: 50.h,
                child: CategoryFilterBar(
                  categories: controller.categories,
                  selectedCategory: controller.selectedCategory,
                  onCategorySelected: (category) {
                    controller.onCategorySelected(category);
                    searchController.clear();
                    if (category == 'الكل') {
                      controller.fetchAllProducts();
                    } else {
                      controller.fetchProductsByCategory();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            if (!controller.isListLoaded)
              const Expanded( // Use Expanded to allow CircularProgressIndicator to take available space
                child: Center(child: CircularProgressIndicator()),
              )
            else if (controller.filteredProducts.isEmpty)
              Expanded( // Use Expanded
                child: Center(
                  child: Text(
                    'لا توجد منتجات متاحة لهذه الفئة.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.sp,
                      fontFamily: baseFont,
                    ),
                  ),
                ),
              )
            else
              Expanded( // Wrap ListView.separated with Expanded
                child: ListView.separated(
                  itemCount: controller.filteredProducts.length,
                  // REMOVE physics: const NeverScrollableScrollPhysics(),
                  // REMOVE shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final product = controller.filteredProducts[index];
                    // Ensure productId is reliably unique, fallback to productName or a generated key
                    final String quantityKey = product.productId?.toString() ?? product.productName ?? 'product_${index}';

                    return Padding( // Add padding around each card if needed, or keep it in ProductItemCard
                      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Apply horizontal padding here
                      child: Column(
                        children: [
                          ProductItemCard(
                            product: product,
                            quantity: controller.productQuantities[quantityKey] ?? 0,
                            onQuantityChanged: (newQuantity) {
                              controller.onQuantityChanged(quantityKey, newQuantity);
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
                              onPressed: () => controller.addToCart(product),
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
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: controller.cart.isNotEmpty
          ? FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.33,
              minChildSize: 0.33,
              maxChildSize: 0.33,
              expand: false,
              builder: (context, scrollController) {
                return CartSheet(
                  cart: controller.cart,
                  total: controller.cartTotal,
                  onClose: () => Navigator.pop(context),
                );
              },
            ),
          );
        },
        label: Text(
          'السلة (${controller.cart.length})',
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
  }}