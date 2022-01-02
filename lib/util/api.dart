import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:khind/util/key.dart';

final storage = new FlutterSecureStorage();

class AuthInterceptor implements InterceptorContract {
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
      print('Auth Interceptor error $e');
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}

class ApiInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      data.headers['Content-Type'] = 'application/json';
      data.headers['Accept'] = 'application/json';

      var token = await storage.read(key: TOKEN);
      print('TOKEN: $token');
      if (token != null) {
        String bearerAuth = 'Bearer $token';
        data.headers['authorization'] = bearerAuth;
      }
    } catch (e) {
      print('Api Interceptor error $e');
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}

class Api {
  static http.Client authClient = InterceptedClient.build(interceptors: [AuthInterceptor()]);
  static http.Client client = InterceptedClient.build(interceptors: [ApiInterceptor()]);

  static basicPost(endpoint, {params, isCms = false}) async {
    try {
      final response;
      String baseUrl = isCms ? dotenv.env["CMS_URL"] as String : dotenv.env["API_URL"] as String;
      String url = '$baseUrl/$endpoint';
      print("Url: $url");
      if (params != null) {
        response = await authClient.post(url.toUri(), body: params);
      } else {
        response = await authClient.post(url.toUri());
      }
      print('Basic Response: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('Post error : $e');
      return {'error': e.toString()};
    }
  }

  static bearerGet(endpoint, {params, isCms = false}) async {
    try {
      String newParams = "";
      int cnt = 0;
      if (params != null) {
        params.forEach((key, val) {
          // print(key);
          if (cnt == 0) {
            newParams = '?$key=$val';
            return;
          }
          newParams += '&$val';
          cnt++;
        });
      }

      print("#NEWPARAMS: $newParams");

      String baseUrl = isCms ? dotenv.env["CMS_URL"] as String : dotenv.env["API_URL"] as String;
      String url = params != null ? '$baseUrl/$endpoint$newParams' : '$baseUrl/$endpoint';
      print("Url: $url");
      final response = await client.get(url.toUri());
      print('Bearer Response: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('Get error : $e');
      return {'error': e.toString()};
    }
  }

  static bearerPost(endpoint, {params, isCms = false}) async {
    try {
      final response;
      String baseUrl = isCms ? dotenv.env["CMS_URL"] as String : dotenv.env["API_URL"] as String;
      String url = '$baseUrl/$endpoint';
      print("Url: $url");
      if (params != null) {
        response = await client.post(url.toUri(), body: params);
      } else {
        response = await client.post(url.toUri());
      }
      print('Bearer Response: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('Post error : $e');
      return {'error': e.toString()};
    }
  }
}
