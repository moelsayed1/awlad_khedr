import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/assets.dart';
import 'package:awlad_khedr/features/invoice/data/invoice_service.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

/// Helper function to extract userId from JWT token
String? extractUserIdFromToken(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final payloadMap = json.decode(payload);
    return payloadMap['sub']?.toString();
  } catch (e) {
    return null;
  }
}

// ignore: must_be_immutable
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
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("جاري إرسال الطلب..."),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showOrderSuccessDialog(String? invoiceNo) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
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
              fontWeight: FontWeight.w700),
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

  Future<bool> _addProductsToCart(String? token, String? userId) async {
    bool cartSuccess = true;
    for (int i = 0; i < widget.products.length; i++) {
      final product = widget.products[i];
      final quantity = widget.quantities[i];
      final price = product.price.toString();
      final totalPrice = (double.tryParse(price)! * quantity).toString();
      final cartResponse = await http.post(
        Uri.parse(APIConstant.GET_CART), // Should be ADD_TO_CART endpoint
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "user_id": userId,
          "product_id": product.productId.toString(),
          "product_quantity": quantity.toString(),
          "price": price,
          "total_price": totalPrice,
        }),
      );
      log('Add to cart response [ [33m${cartResponse.statusCode} [0m]: ${cartResponse.body}');
      if (cartResponse.statusCode != 200 && cartResponse.statusCode != 201) {
        cartSuccess = false;
        break;
      }
    }
    return cartSuccess;
  }

  Future<void> _storeOrder(String? token) async {
    final orderResponse = await http.post(
      Uri.parse(APIConstant.STORE_SELL),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({}),
    );
    log('Store order response [ [33m${orderResponse.statusCode} [0m]: ${orderResponse.body}');
    Navigator.of(context).pop(); // Close loading dialog
    if (orderResponse.statusCode == 200 || orderResponse.statusCode == 201) {
      final data = json.decode(orderResponse.body);
      final invoiceNo = data["transaction"]?["invoice_no"];
      await _showOrderSuccessDialog(invoiceNo);
      widget.onOrderConfirmed();
    } else {
      _showSnackBar(
        'حدث خطأ أثناء إرسال الطلب. حاول مرة أخرى.',
        backgroundColor: darkOrange,
        textColor: Colors.black,
      );
    }
  }

  Future<void> _handleOrder() async {
    if (widget.count < 3000) {
      _showSnackBar(
        'الحد الادني للاوردر 3000 جنيه لاستكمال الطلب',
        backgroundColor: darkOrange,
        textColor: Colors.black,
      );
      return;
    }

    await _showLoadingDialog();

    final token = await InvoiceService.getToken();
    final userId = extractUserIdFromToken(token ?? '');
    log('Extracted userId from token: $userId');

    final cartSuccess = await _addProductsToCart(token, userId);

    if (cartSuccess) {
      await _storeOrder(token);
    } else {
      Navigator.of(context).pop(); // Close loading dialog
      _showSnackBar(
        'حدث خطأ أثناء إضافة المنتجات للسلة. حاول مرة أخرى.',
        backgroundColor: darkOrange,
        textColor: Colors.black,
      );
    }
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
          onPressed: () async {
            if (widget.count >= 3000) {
              try {
                // Show loading dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      content: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 20),
                          Text("جاري إرسال الطلب..."),
                        ],
                      ),
                    );
                  },
                );

                final token = await InvoiceService.getToken();
                final userId = extractUserIdFromToken(token ?? '');
                log('Extracted userId from token: $userId');

                bool cartSuccess = true;
                for (int i = 0; i < widget.products.length; i++) {
                  final product = widget.products[i];
                  final quantity = widget.quantities[i];
                  final price = product.price.toString();
                  final totalPrice = (double.tryParse(price)! * quantity).toString();
                  final cartResponse = await http.post(
                    Uri.parse(APIConstant.GET_CART), // Should be ADD_TO_CART endpoint
                    headers: {
                      'Authorization': 'Bearer $token',
                      'Content-Type': 'application/json',
                    },
                    body: json.encode({
                      "user_id": userId,
                      "product_id": product.productId.toString(),
                      "product_quantity": quantity.toString(),
                      "price": price,
                      "total_price": totalPrice,
                    }),
                  );
                  log('Add to cart response [ [33m${cartResponse.statusCode} [0m]: ${cartResponse.body}');
                  if (cartResponse.statusCode != 200 && cartResponse.statusCode != 201) {
                    cartSuccess = false;
                    break;
                  }
                }

                if (cartSuccess) {
                  // Now store the order
                  final orderResponse = await http.post(
                    Uri.parse(APIConstant.STORE_SELL),
                    headers: {
                      'Authorization': 'Bearer $token',
                      'Content-Type': 'application/json',
                    },
                    body: json.encode({}), // If API expects empty body
                  );
                  log('Store order response [ [33m${orderResponse.statusCode} [0m]: ${orderResponse.body}');
                  Navigator.of(context).pop(); // Close loading dialog
                  if (orderResponse.statusCode == 200 || orderResponse.statusCode == 201) {
                    final data = json.decode(orderResponse.body);
                    final invoiceNo = data["transaction"]?["invoice_no"];
                    await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
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
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    );
                    widget.onOrderConfirmed();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: darkOrange,
                        content: Text(
                          textAlign: TextAlign.center,
                          'حدث خطأ أثناء إرسال الطلب. حاول مرة أخرى.',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ),
                      ),
                    );
                  }
                } else {
                  Navigator.of(context).pop(); // Close loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: darkOrange,
                      content: Text(
                        textAlign: TextAlign.center,
                        'حدث خطأ أثناء إضافة المنتجات للسلة. حاول مرة أخرى.',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                }
              } catch (e, stack) {
                Navigator.of(context).pop(); // Close loading dialog if open
                log('Exception during order: $e\n$stack');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: darkOrange,
                    content: Text(
                      textAlign: TextAlign.center,
                      'حدث خطأ غير متوقع أثناء إرسال الطلب.',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ),
                );
              }
            } else {
              _showSnackBar(
                'الحد الادني للاوردر 3000 جنيه لاستكمال الطلب',
                backgroundColor: darkOrange,
                textColor: Colors.black,
              );
            }
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
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: baseFont),
                ),
        ),
      ),
    );
  }
}
