import 'dart:developer';
import 'dart:io';

import 'package:khind/models/product_group.dart';
import 'package:khind/models/product_group_model.dart';
import 'package:khind/models/store.dart';
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

  static Future<bool> registerEwarranty({
    required String email,
    required String productModel,
    required String quantity,
    required String purchaseDate,
    required String referralCode,
    required File receiptFile,
  }) async {
    final Map<String, String> data = {
      'email': email,
      'product_model': productModel,
      'qty': quantity,
      'purchase_date': purchaseDate,
      'referral_code': referralCode,
      // 'receipt_file': receiptFile,
    };

    print(data);

    // String queryString = Uri(queryParameters: queryParameters).query;

    var url = Uri.parse(Api.endpoint + Api.REGISTER_EWARRANTY);
    Map<String, String> authHeader = {
      'Content-Type': 'application/json',
      'Authorization': Api.defaultToken,
    };

    print(url);
    print('calling register warranty');

    var request = http.MultipartRequest(
      'POST',
      url,
    );

    request.fields.addAll(data);
    request.headers.addAll(authHeader);

    var multipartFile =
        await http.MultipartFile.fromPath('receipt_file', receiptFile.path);
    request.files.add(multipartFile);

    http.StreamedResponse response = await request.send();

    final respStr = await response.stream.bytesToString();

    print(respStr);

    if (respStr.contains('false')) {
      return false;
    } else {
      return true;
    }

    // final response = await http.post(
    //   url,
    //   headers: authHeader,
    // );

    // print(response.body);
  }

  static Future<String> getServiceProduct() async {
    final queryParameters = {
      // 'email': 'khindcustomerservice@gmail.com',
      'email': '',
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

  static Future<ProductGroup> getProductGroup() async {
    // final queryParameters = {
    //   'email': 'khindcustomerservice@gmail.com',
    // };

    // String queryString = Uri(queryParameters: queryParameters).query;

    var url = Uri.parse(Api.endpoint + Api.GET_PRODUCT_GROUP);
    Map<String, String> authHeader = {
      'Content-Type': 'application/json',
      'Authorization': Api.defaultToken,
    };

    print(url);
    print('calling product group');

    final response = await http.get(
      url,
      headers: authHeader,
    );
    ProductGroup productGroup;

    try {
      productGroup = productGroupFromJson(response.body);
    } catch (e) {
      productGroup = ProductGroup(data: []);
    }

    return productGroup;
  }

  static Future<ProductGroupModel> getProductModel(
      {required String productGroup}) async {
    var url = Uri.parse(Api.endpoint +
        Api.GET_PRODUCT_WARRANTY +
        "?product_group_desc=$productGroup");
    Map<String, String> authHeader = {
      'Content-Type': 'application/json',
      'Authorization': Api.defaultToken,
    };

    print(url);
    print('calling product model');

    final response = await http.post(
      url,
      headers: authHeader,
    );

    // log(response.body);

    ProductGroupModel productModel;

    try {
      productModel = productGroupModelFromJson(response.body);
    } catch (e) {
      productModel = ProductGroupModel(data: []);
    }
    return productModel;
  }

  static Future<bool> sendExtend({required String warrantyId}) async {
    var url = Uri.parse(Api.endpoint +
        Api.EXTEND_WARRANTY +
        "?warranty_registration_id=$warrantyId");
    Map<String, String> authHeader = {
      'Content-Type': 'application/json',
      'Authorization': Api.defaultToken,
    };

    print(url);
    print('calling extend warranty');

    final response = await http.post(
      url,
      headers: authHeader,
    );

    if (response.body.contains('false')) {
      return false;
    } else {
      return true;
    }
  }

  static Future<Store> getStore() async {
    // final queryParameters = {
    //   'email': 'khindcustomerservice@gmail.com',
    // };

    // String queryString = Uri(queryParameters: queryParameters).query;

    var url = Uri.parse(Api.endpoint + Api.GET_STORE);
    Map<String, String> authHeader = {
      'Content-Type': 'application/json',
      'Authorization': Api.defaultToken,
    };

    print(url);
    print('calling product group');

    final response = await http.get(
      url,
      headers: authHeader,
    );

    Store store = storeFromJson(response.body);
    return store;
  }

  static Future<List<String>> getProductModelList(
      List<String> productModel, String pattern) async {
    List<String> matchedModel = [];
    for (var i = 0; i < productModel.length; i++) {
      if (productModel[i].toLowerCase().contains(pattern.toLowerCase())) {
        matchedModel.add(productModel[i]);
      }
    }

    return matchedModel;
  }
}
