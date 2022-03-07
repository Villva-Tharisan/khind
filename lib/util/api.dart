import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:khind/util/key.dart';

final storage = new FlutterSecureStorage();

class AuthInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      String username = FlutterConfig.get("CLIENT_USERNAME");
      String password = FlutterConfig.get("CLIENT_PASSWORD") as String;
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
      // print('BasicAuth $basicAuth');
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
        data.headers['Authorization'] = bearerAuth;
        print("#HEADERS: ${bearerAuth}");
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
      String baseUrl = isCms ? FlutterConfig.get("CMS_URL") : FlutterConfig.get("API_URL");
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
      final response;
      String baseUrl = isCms ? FlutterConfig.get("CMS_URL") : FlutterConfig.get("API_URL");
      String url = '$baseUrl/$endpoint';

      print("Url: $url");

      if (params != null) {
        response = await client.get(Uri.parse(url).replace(queryParameters: params));
      } else {
        response = await client.get(url.toUri());
      }

      print('Bearer Response: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('Get error : $e');
      return {'error': e.toString()};
    }
  }

  static bearerPost(endpoint, {params, queryParams, isCms = false}) async {
    try {
      final response;
      String baseUrl = isCms ? FlutterConfig.get("CMS_URL") : FlutterConfig.get("API_URL");
      String url = '$baseUrl/$endpoint';

      if (queryParams != null) {
        List<String> listParams = [];
        int cnt = 0;
        queryParams.forEach((key, val) {
          if (cnt == 0) {
            cnt++;
            listParams.add('?$key=$val');
            return;
          }
          listParams.add('&$key=$val');
          cnt++;
        });

        if (listParams.length > 0) {
          // print('#LISTPARAMS: ${listParams.join()}');
          url = '$url${listParams.join()}';
        }
      }

      print("bearerPost Url: $url");
      if (params != null) {
        response = await client.post(url.toUri(), body: params);
      } else {
        response = await client.post(url.toUri());
      }
      print('Bearer Response: ${response.body}');
      try {
        json.decode(response.body) as Map<String, dynamic>;

        return json.decode(response.body);
      } on FormatException catch (e) {
        return response.body;
        // return {'success': false};
        // print('The provided string is not valid JSON');
      }
    } catch (e) {
      print('Post error : $e');
      return {'error': e.toString()};
    }
  }

  static customPost(endpoint, {headers, params, queryParams, isRest = false}) async {
    try {
      final response;
      String baseUrl = isRest ? FlutterConfig.get("API_URL") : FlutterConfig.get("API_ADMIN_URL");
      String url = '$baseUrl/$endpoint';

      if (queryParams != null) {
        List<String> listParams = [];
        int cnt = 0;
        queryParams.forEach((key, val) {
          if (cnt == 0) {
            cnt++;
            listParams.add('?$key=$val');
            return;
          }
          listParams.add('&$key=$val');
          cnt++;
        });

        if (listParams.length > 0) {
          // print('#LISTPARAMS: ${listParams.join()}');
          url = '$url${listParams.join()}';
        }
      }

      print("Url: $url");

      if (params != null) {
        response = await http.post(url.toUri(), body: params, headers: headers);
      } else {
        response = await http.post(url.toUri(), headers: headers);
      }
      print('customPost Response: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('customPost error : $e');
      return {'error': e.toString()};
    }
  }

  static customPut(endpoint, {headers, params, queryParams, isRest = false}) async {
    // print("HEADESR: $headers");
    try {
      final response;
      String baseUrl = isRest ? FlutterConfig.get("API_URL") : FlutterConfig.get("API_ADMIN_URL");
      String url = '$baseUrl/$endpoint';

      if (queryParams != null) {
        List<String> listParams = [];
        int cnt = 0;
        queryParams.forEach((key, val) {
          if (cnt == 0) {
            cnt++;
            listParams.add('?$key=$val');
            return;
          }
          listParams.add('&$key=$val');
          cnt++;
        });

        if (listParams.length > 0) {
          // print('#LISTPARAMS: ${listParams.join()}');
          url = '$url${listParams.join()}';
        }
      }

      print("Url: $url");
      if (params != null) {
        response = await http.put(url.toUri(), body: params, headers: headers);
      } else {
        response = await http.put(url.toUri(), headers: headers);
      }
      print('customPut Response: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('customPut error : $e');
      return {'error': e.toString()};
    }
  }
}
