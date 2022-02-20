// To parse this JSON data, do
//
//     final productWarranty = productWarrantyFromJson(jsonString);

import 'dart:convert';

ProductWarranty productWarrantyFromJson(String str) =>
    ProductWarranty.fromJson(json.decode(str));

String productWarrantyToJson(ProductWarranty data) =>
    json.encode(data.toJson());

class ProductWarranty {
  ProductWarranty({
    this.data,
  });

  List<Datum>? data;

  factory ProductWarranty.fromJson(Map<String, dynamic> json) =>
      ProductWarranty(
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
    this.productGroupId,
    this.productGroupDescription,
    this.productModelId,
    this.productModel,
    this.modelDescription,
    this.specificWarranty,
    this.dropIn,
    this.homeVisit,
    this.pickUp,
    this.extendedWarrantyCost,
    this.warrantyDescription,
    this.warrantyMonths,
  });

  String? productGroupId;
  String? productGroupDescription;
  String? productModelId;
  String? productModel;
  String? modelDescription;
  dynamic specificWarranty;
  String? dropIn;
  String? homeVisit;
  String? pickUp;
  String? extendedWarrantyCost;
  String? warrantyDescription;
  String? warrantyMonths;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        productGroupId:
            json["product_group_id"] == null ? null : json["product_group_id"],
        productGroupDescription: json["product_group_description"] == null
            ? null
            : json["product_group_description"],
        productModelId:
            json["product_model_id"] == null ? null : json["product_model_id"],
        productModel:
            json["product_model"] == null ? null : json["product_model"],
        modelDescription: json["model_description"] == null
            ? null
            : json["model_description"],
        specificWarranty: json["specific_warranty"],
        dropIn: json["drop_in"] == null ? null : json["drop_in"],
        homeVisit: json["home_visit"] == null ? null : json["home_visit"],
        pickUp: json["pick_up"] == null ? null : json["pick_up"],
        extendedWarrantyCost: json["extended_warranty_cost"] == null
            ? null
            : json["extended_warranty_cost"],
        warrantyDescription: json["warranty_description"] == null
            ? null
            : json["warranty_description"],
        warrantyMonths:
            json["warranty_months"] == null ? null : json["warranty_months"],
      );

  Map<String, dynamic> toJson() => {
        "product_group_id": productGroupId == null ? null : productGroupId,
        "product_group_description":
            productGroupDescription == null ? null : productGroupDescription,
        "product_model_id": productModelId == null ? null : productModelId,
        "product_model": productModel == null ? null : productModel,
        "model_description": modelDescription == null ? null : modelDescription,
        "specific_warranty": specificWarranty,
        "drop_in": dropIn == null ? null : dropIn,
        "home_visit": homeVisit == null ? null : homeVisit,
        "pick_up": pickUp == null ? null : pickUp,
        "extended_warranty_cost":
            extendedWarrantyCost == null ? null : extendedWarrantyCost,
        "warranty_description":
            warrantyDescription == null ? null : warrantyDescription,
        "warranty_months": warrantyMonths == null ? null : warrantyMonths,
      };
}
