// To parse this JSON data, do
//
//     final productGroupModel = productGroupModelFromJson(jsonString);

import 'dart:convert';

ProductGroupModel productGroupModelFromJson(String str) =>
    ProductGroupModel.fromJson(json.decode(str));

String productGroupModelToJson(ProductGroupModel data) =>
    json.encode(data.toJson());

class ProductGroupModel {
  ProductGroupModel({
    this.data,
  });

  List<Map<String, String>>? data;

  factory ProductGroupModel.fromJson(Map<String, dynamic> json) =>
      ProductGroupModel(
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
