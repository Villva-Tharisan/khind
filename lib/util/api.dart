import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      String username = dotenv.env["CLIENT_USERNAME"] as String;
      String password = dotenv.env["CLIENT_PASSWORD"] as String;
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
      print('BasicAuth $basicAuth');
      data.headers['Content-Type'] = 'application/json';
      data.headers['authorization'] = basicAuth;
    } catch (e) {
      print('Interceptor error $e');
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}

class Api {
  static Client client = InterceptedClient.build(interceptors: [ApiInterceptor()]);

  static get(endpoint, {params}) async {
    try {
      String url = '${(dotenv.env["API_URL"] as String)}/$endpoint';
      print("Url: $url");
      final response = await client.get(url.toUri());
      print('Response: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('Get error : $e');
      return {'error': e.toString()};
    }
  }

  static post(endpoint, {params}) async {
    try {
      final response;
      String url = '${(dotenv.env["API_URL"] as String)}/$endpoint';
      print("Url: $url");
      if (params != null) {
        response = await client.post(url.toUri(), body: params);
      } else {
        response = await client.post(url.toUri());
      }
      print('Response: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('Post error : $e');
      return {'error': e.toString()};
    }
  }
}
