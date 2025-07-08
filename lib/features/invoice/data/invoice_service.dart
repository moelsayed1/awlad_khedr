import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constant.dart';
import 'dart:developer';
import 'store_sell_model.dart';
import 'package:flutter/foundation.dart';

class InvoiceService {
  static String? _cachedToken;

  static Map<String, String> _defaultHeaders(String token) => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  static Future<String?> getToken() async {
    if (_cachedToken != null) {
      debugPrint('[log] Using cached token: $_cachedToken');
      return _cachedToken;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedToken = prefs.getString('token');
      debugPrint('[log] Retrieved token from storage: $_cachedToken');
      return _cachedToken;
    } catch (e, stack) {
      debugPrint('[ERROR] getToken failed: $e');
      debugPrint(stack.toString());
      return null;
    }
  }

  static void clearToken() {
    _cachedToken = null;
    debugPrint('[log] Token cache cleared');
  }

  Future<List<dynamic>> getAllOrders() async {
    final token = await getToken();
    if (token == null) {
      log('[ERROR] Token is null in getAllOrders');
      return [];
    }
    try {
      final response = await http.get(
        Uri.parse(APIConstant.GET_ALL_ORDERS),
        headers: _defaultHeaders(token),
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['orders'] ?? [];
      } else {
        log('[ERROR] getAllOrders failed with status code: ${response.statusCode}');
        log('Response body: ${response.body}');
        return [];
      }
    } catch (e, stack) {
      debugPrint('[ERROR] Exception in getAllOrders: $e');
      debugPrint('Stack trace: $stack');
      return [];
    }
  }

  Future<List<dynamic>> getAllTransactions() async {
    final token = await getToken();
    if (token == null) {
      log('[ERROR] Token is null in getAllTransactions');
      return [];
    }
    try {
      final response = await http.get(
        Uri.parse(APIConstant.GET_ALL_TRANSACTIONS),
        headers: _defaultHeaders(token),
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['transactions'] ?? [];
      } else {
        log('[ERROR] getAllTransactions failed with status code: ${response.statusCode}');
        log('Response body: ${response.body}');
        return [];
      }
    } catch (e, stack) {
      debugPrint('[ERROR] Exception in getAllTransactions: $e');
      debugPrint('Stack trace: $stack');
      return [];
    }
  }

  Future<StoreSellResponse?> storeSell({required List<dynamic> products, required List<int> quantities, required double total}) async {
    final token = await getToken();
    if (token == null) {
      log('[ERROR] Token is null. Cannot proceed with storeSell.');
      return null;
    }
    log('Order API token: ${token ?? 'NULL'}');
    // Build the order payload as expected by your backend
    final List<Map<String, dynamic>> orderItems = [];
    for (int i = 0; i < products.length; i++) {
      final product = products[i];
      if (product is Map<String, dynamic>) {
        orderItems.add({
          'product_id': product['product_id'],
          'quantity': product['quantity'],
          'price': product['price'],
        });
      } else {
        orderItems.add({
          'product_id': product.productId,
          'quantity': quantities[i],
          'price': product.price,
        });
      }
    }
    final Map<String, dynamic> payload = {
      'items': orderItems,
      'total': total,
      // Add other fields if required by your backend
    };
    log('Sending order payload: $payload');
    try {
      final response = await http.post(
        Uri.parse(APIConstant.STORE_SELL),
        headers: _defaultHeaders(token),
        body: json.encode(payload),
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return StoreSellResponse.fromJson(data);
      } else {
        log('[ERROR] storeSell failed with status code: ${response.statusCode}');
        log('Response body: ${response.body}');
        return null;
      }
    } catch (e, stack) {
      log('[ERROR] Exception in storeSell: $e');
      log('Stack trace: $stack');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getOrder(int orderId) async {
    final token = await getToken();
    if (token == null) {
      log('[ERROR] Token is null in getOrder');
      return null;
    }
    try {
      final response = await http.get(
        Uri.parse('${APIConstant.GET_ORDER}/$orderId'),
        headers: _defaultHeaders(token),
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['order'];
      } else {
        log('[ERROR] getOrder failed with status code: ${response.statusCode}');
        log('Response body: ${response.body}');
        return null;
      }
    } catch (e, stack) {
      debugPrint('[ERROR] Exception in getOrder: $e');
      debugPrint('Stack trace: $stack');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getOrderInvoice(int orderId) async {
    final token = await getToken();
    if (token == null) {
      log('[ERROR] Token is null in getOrderInvoice');
      return null;
    }
    try {
      final response = await http.get(
        Uri.parse('${APIConstant.GET_ORDER_INVOICE}/$orderId'),
        headers: _defaultHeaders(token),
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['order-invoice'];
      } else {
        log('[ERROR] getOrderInvoice failed with status code: ${response.statusCode}');
        log('Response body: ${response.body}');
        return null;
      }
    } catch (e, stack) {
      debugPrint('[ERROR] Exception in getOrderInvoice: $e');
      debugPrint('Stack trace: $stack');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTransactionInvoice(int transactionId) async {
    final token = await getToken();
    if (token == null) {
      log('[ERROR] Token is null in getTransactionInvoice');
      return null;
    }
    try {
      final response = await http.get(
        Uri.parse('${APIConstant.GET_TRANSACTION_INVOICE}/$transactionId'),
        headers: _defaultHeaders(token),
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['order-invoice'];
      } else {
        log('[ERROR] getTransactionInvoice failed with status code: ${response.statusCode}');
        log('Response body: ${response.body}');
        return null;
      }
    } catch (e, stack) {
      debugPrint('[ERROR] Exception in getTransactionInvoice: $e');
      debugPrint('Stack trace: $stack');
      return null;
    }
  }
} 