import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constant.dart';
import 'dart:developer';
import 'store_sell_model.dart';

class InvoiceService {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<dynamic>> getAllOrders() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(APIConstant.GET_ALL_ORDERS),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['orders'] ?? [];
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<List<dynamic>> getAllTransactions() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(APIConstant.GET_ALL_TRANSACTIONS),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['transactions'] ?? [];
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  Future<StoreSellResponse?> storeSell({required List<dynamic> products, required List<int> quantities, required double total}) async {
    final token = await getToken();
    log('Order API token: ' + (token ?? 'NULL'));
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
    log('Sending order payload: ' + payload.toString());
    final response = await http.post(
      Uri.parse(APIConstant.STORE_SELL),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(payload),
    );
    log('Order response status code:  [33m${response.statusCode} [0m');
    log('Order response body: ' + response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return StoreSellResponse.fromJson(data);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getOrder(int orderId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('${APIConstant.GET_ORDER}/$orderId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['order'];
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getOrderInvoice(int orderId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('${APIConstant.GET_ORDER_INVOICE}/$orderId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['order-invoice'];
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTransactionInvoice(int transactionId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('${APIConstant.GET_TRANSACTION_INVOICE}/$transactionId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['order-invoice'];
    } else {
      return null;
    }
  }
} 