// To parse this JSON data, do
//
//     final serviceProduct = serviceProductFromJson(jsonString);

import 'dart:convert';

ServiceProduct serviceProductFromJson(String str) =>
    ServiceProduct.fromJson(json.decode(str));

String serviceProductToJson(ServiceProduct data) => json.encode(data.toJson());

class ServiceProduct {
  ServiceProduct({
    this.data,
  });

  List<Map<String, String>>? data;

  factory ServiceProduct.fromJson(Map<String, dynamic> json) => ServiceProduct(
        data: json["data"] == null
            ? null
            : List<Map<String, String>>.from(json["data"].map((x) => Map.from(x)
                .map((k, v) =>
                    MapEntry<String, String>(k, v == null ? 'null' : v)))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => Map.from(x).map(
                (k, v) => MapEntry<String, dynamic>(k, v == null ? null : v)))),
      };
}
