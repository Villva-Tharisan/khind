import 'package:khind/models/product_warranty.dart';
import 'package:khind/services/api.dart';
import 'package:http/http.dart' as http;

class Repositories {
  static Future<String> getProduct({required String productModel}) async {
    var url = Uri.parse(Api.endpoint +
        Api.GET_PRODUCT_WARRANTY +
        "?product_model=$productModel");
    Map<String, String> authHeader = {
      'Content-Type': 'application/json',
      'Authorization': Api.defaultToken,
    };

    print(url);
    print('calling product warranty');

    final response = await http.post(
      url,
      headers: authHeader,
    );

    return response.body;
  }

  static Future<void> registerEwarranty({
    required String email,
    required String productModel,
    required String quantity,
    required String purchaseDate,
    required String referralCode,
    required String receiptFile,
  }) async {
    final queryParameters = {
      'email': email,
      'product_model': productModel,
      'qty': quantity,
      'purchase_date': purchaseDate,
      'referral_code': quantity,
      'receipt_file': receiptFile,
    };

    String queryString = Uri(queryParameters: queryParameters).query;

    var url =
        Uri.parse(Api.endpoint + Api.REGISTER_EWARRANTY + '?' + queryString);
    Map<String, String> authHeader = {
      'Content-Type': 'application/json',
      'Authorization': Api.defaultToken,
    };

    print(url);
    print('calling register warranty');

    final response = await http.post(
      url,
      headers: authHeader,
    );

    print(response.body);
  }

  static Future<String> getServiceProduct() async {
    final queryParameters = {
      'email': 'khindcustomerservice@gmail.com',
    };

    String queryString = Uri(queryParameters: queryParameters).query;

    var url =
        Uri.parse(Api.endpoint + Api.GET_SERVICE_PRODUCT + '?' + queryString);
    Map<String, String> authHeader = {
      'Content-Type': 'application/json',
      'Authorization': Api.defaultToken,
    };

    print(url);
    print('calling product warranty');

    final response = await http.post(
      url,
      headers: authHeader,
    );

    return response.body;
  }
}
