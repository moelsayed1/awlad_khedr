import 'dart:developer';

import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/assets.dart';
import 'package:awlad_khedr/features/invoice/data/invoice_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Helper function to extract userId from JWT token
String? extractUserIdFromToken(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final payloadMap = json.decode(payload);
    final userId = payloadMap['sub']?.toString();
    debugPrint('[log] Extracted userId from token: $userId');
    return userId;
  } catch (e) {
    debugPrint('[log] Exception in extractUserIdFromToken: $e');
    return null;
  }
}

/// Logic class to handle cart/order operations
class CartOrderLogic {
  final List<dynamic> products;
  final List<int> quantities;
  final double count;

  CartOrderLogic({
    required this.products,
    required this.quantities,
    required this.count,
  });

  Future<bool> addProductsToCart(String? token) async {
    debugPrint('Starting addProductsToCart');
    for (int i = 0; i < products.length; i++) {
      final product = products[i];
      final quantity = quantities[i];
      final price = product.price.toString();
      final requestBody = {
        "product_id": product.productId.toString(),
        "product_quantity": quantity.toString(),
        "price": price,
      };
      debugPrint('About to send add-to-cart request');
      debugPrint('Add to cart request body: ${json.encode(requestBody)}');
      try {
        final cartResponse = await http.post(
          Uri.parse(APIConstant.GET_CART),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode(requestBody),
        ).timeout(const Duration(seconds: 10));
        debugPrint('Add to cart response status: ${cartResponse.statusCode}');
        debugPrint('Add to cart response body: ${cartResponse.body}');
        if (cartResponse.statusCode != 200 && cartResponse.statusCode != 201) {
          return false;
        }
      } catch (e, stack) {
        debugPrint('Exception during add to cart: $e');
        debugPrint('Stack trace: $stack');
        return false;
      }
    }
    return true;
  }

  Future<Map<String, dynamic>?> storeOrder(String? token) async {
    try {
      final orderResponse = await http.post(
        Uri.parse(APIConstant.STORE_SELL),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({}),
      );
      debugPrint('Store order response [ [33m${orderResponse.statusCode} [0m]: ${orderResponse.body}');
      if (orderResponse.statusCode == 200 || orderResponse.statusCode == 201) {
        final data = json.decode(orderResponse.body);
        return data;
      } else {
        return null;
      }
    } catch (e, stack) {
      debugPrint('Exception during store order: $e');
      debugPrint('Stack trace: $stack');
      return null;
    }
  }
}

class CustomButtonCart extends StatefulWidget {
  final List<dynamic> products;
  final List<int> quantities;
  final double count;
  final VoidCallback onOrderConfirmed;

  const CustomButtonCart({
    super.key,
    required this.count,
    required this.onOrderConfirmed,
    required this.products,
    required this.quantities,
  });

  @override
  State<CustomButtonCart> createState() => _CustomButtonCartState();
}

class _CustomButtonCartState extends State<CustomButtonCart> {
  bool _isLoading = false;

  Future<void> _showLoadingDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("جاري إرسال الطلب..."),
          ],
        ),
      ),
    );
  }

  Future<void> _showOrderSuccessDialog(String? invoiceNo) async {
    await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Image.asset(
          AssetsData.bag,
          width: 100,
          height: 100,
        ),
        content: Text(
          textAlign: TextAlign.center,
          'تم تأكيد طلبك بنجاح${invoiceNo != null ? "\nرقم الفاتورة: $invoiceNo" : ""}',
          style: TextStyle(
            fontFamily: baseFont,
            fontSize: 25.sp,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message, {Color? backgroundColor, Color? textColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor ?? darkOrange,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor ?? Colors.black,
            fontWeight: FontWeight.w700,
            fontFamily: baseFont,
          ),
        ),
      ),
    );
  }

  Future<void> _handleOrder() async {
    debugPrint('Order Now button pressed');
    debugPrint('Starting _handleOrder');
    if (_isLoading) return;
    setState(() => _isLoading = true);

    if (widget.count < 3000) {
      _showSnackBar(
        'الحد الادني للاوردر 3000 جنيه لاستكمال الطلب',
        backgroundColor: darkOrange,
        textColor: Colors.black,
      );
      setState(() => _isLoading = false);
      return;
    }
    debugPrint('Passed minimum order check');
    await _showLoadingDialog();
    await Future.delayed(const Duration(milliseconds: 300));

    debugPrint('[DEBUG] قبل getToken');
    final token = await InvoiceService.getToken();
    debugPrint('[DEBUG] بعد getToken: $token');

    if (token == null) {
      Navigator.of(context).pop(); // اقفل الـ dialog
      _showSnackBar('لم يتم العثور على التوكن. أعد تسجيل الدخول.', backgroundColor: Colors.red, textColor: Colors.white);
      setState(() => _isLoading = false);
      return;
    }

    String? userId = extractUserIdFromToken(token);
    debugPrint('[log] Extracted userId from token: $userId');
    debugPrint('Before calling addProductsToCart');

    final logic = CartOrderLogic(
      products: widget.products,
      quantities: widget.quantities,
      count: widget.count,
    );

    final cartSuccess = await logic.addProductsToCart(token);
    debugPrint('Cart success: $cartSuccess');
    if (cartSuccess) {
      final orderData = await logic.storeOrder(token);
      Navigator.of(context).pop(); // Close loading dialog
      if (orderData != null) {
        final invoiceNo = orderData["transaction"]?["invoice_no"];
        await _showOrderSuccessDialog(invoiceNo);
        widget.onOrderConfirmed();
      } else {
        _showSnackBar(
          'حدث خطأ أثناء إرسال الطلب. حاول مرة أخرى.',
          backgroundColor: darkOrange,
          textColor: Colors.black,
        );
      }
    } else {
      Navigator.of(context).pop(); // Close loading dialog
      _showSnackBar(
        'حدث خطأ أثناء إضافة المنتجات للسلة. حاول مرة أخرى.',
        backgroundColor: darkOrange,
        textColor: Colors.black,
      );
      setState(() => _isLoading = false);
      return;
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 32.h,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(mainColor),
          ),
          onPressed: () {
            log('addProductsToCart: ${CartOrderLogic(products: widget.products, quantities: widget.quantities, count: widget.count).addProductsToCart}');
            log('storeOrder: ${CartOrderLogic(products: widget.products, quantities: widget.quantities, count: widget.count).storeOrder}');
          },
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'اطلب الان',
                  style: TextStyle(
                    color: Color.fromARGB(255, 211, 160, 160),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: baseFont,
                  ),
                ),
        ),
      ),
    );
  }
}
