// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.productModel,
  });

  String? productModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        productModel:
            json["Product_model"] == null ? null : json["Product_model"],
      );

  Map<String, dynamic> toJson() => {
        "Product_model": productModel == null ? null : productModel,
      };
}
