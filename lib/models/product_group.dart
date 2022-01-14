// To parse this JSON data, do
//
//     final productGroup = productGroupFromJson(jsonString);

import 'dart:convert';

ProductGroup productGroupFromJson(String str) =>
    ProductGroup.fromJson(json.decode(str));

String productGroupToJson(ProductGroup data) => json.encode(data.toJson());

class ProductGroup {
  ProductGroup({
    this.data,
  });

  List<Datum>? data;

  factory ProductGroup.fromJson(Map<String, dynamic> json) => ProductGroup(
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.productGroupDescription,
  });

  String? productGroupDescription;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        productGroupDescription: json["product_group_description"] == null
            ? null
            : json["product_group_description"],
      );

  Map<String, dynamic> toJson() => {
        "product_group_description":
            productGroupDescription == null ? null : productGroupDescription,
      };
}
