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
    this.productId,
    this.productGroupId,
    this.productModelId,
    this.warrantyId,
    this.productCode,
    this.productDescription,
    this.insertedAt,
    this.updatedAt,
    this.productGroup,
    this.productGroupDescription,
    this.productModel,
    this.modelDescription,
    this.mapToProductCode,
    this.isActive,
    this.specificWarranty,
    this.dropIn,
    this.homeVisit,
    this.pickUp,
    this.serviceHours,
    this.technicianServiceGroup,
    this.rcp,
    this.extendedWarrantyCharge1Yr,
    this.repairWithPartRepChargeIndoor,
    this.checkingAdjChargeIndoor,
    this.checkingAdjChargeOutdoor,
    this.repairWithPartRepChargeOutdoor,
    this.grrCharge,
    this.transportChargeLess50Km,
    this.transportChargeBetween50Km100Km,
    this.transportChargeGreater100Km,
  });

  String? productId;
  String? productGroupId;
  String? productModelId;
  String? warrantyId;
  String? productCode;
  String? productDescription;
  DateTime? insertedAt;
  String? updatedAt;
  String? productGroup;
  String? productGroupDescription;
  String? productModel;
  String? modelDescription;
  String? mapToProductCode;
  String? isActive;
  String? specificWarranty;
  String? dropIn;
  String? homeVisit;
  String? pickUp;
  String? serviceHours;
  String? technicianServiceGroup;
  String? rcp;
  String? extendedWarrantyCharge1Yr;
  String? repairWithPartRepChargeIndoor;
  String? checkingAdjChargeIndoor;
  String? checkingAdjChargeOutdoor;
  String? repairWithPartRepChargeOutdoor;
  String? grrCharge;
  String? transportChargeLess50Km;
  String? transportChargeBetween50Km100Km;
  String? transportChargeGreater100Km;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        productId: json["product_id"] == null ? null : json["product_id"],
        productGroupId:
            json["product_group_id"] == null ? null : json["product_group_id"],
        productModelId:
            json["product_model_id"] == null ? null : json["product_model_id"],
        warrantyId: json["warranty_id"] == null ? null : json["warranty_id"],
        productCode: json["product_code"] == null ? null : json["product_code"],
        productDescription: json["product_description"] == null
            ? null
            : json["product_description"],
        insertedAt: json["inserted_at"] == null
            ? null
            : DateTime.parse(json["inserted_at"]),
        updatedAt: json["updated_at"],
        productGroup:
            json["product_group"] == null ? null : json["product_group"],
        productGroupDescription: json["product_group_description"] == null
            ? null
            : json["product_group_description"],
        productModel:
            json["product_model"] == null ? null : json["product_model"],
        modelDescription: json["model_description"] == null
            ? null
            : json["model_description"],
        mapToProductCode: json["map_to_product_code"] == null
            ? null
            : json["map_to_product_code"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        specificWarranty: json["specific_warranty"],
        dropIn: json["drop_in"] == null ? null : json["drop_in"],
        homeVisit: json["home_visit"] == null ? null : json["home_visit"],
        pickUp: json["pick_up"] == null ? null : json["pick_up"],
        serviceHours:
            json["service_hours"] == null ? null : json["service_hours"],
        technicianServiceGroup: json["technician_service_group"] == null
            ? null
            : json["technician_service_group"],
        rcp: json["rcp"] == null ? null : json["rcp"],
        extendedWarrantyCharge1Yr: json["extended_warranty_charge_1yr"] == null
            ? null
            : json["extended_warranty_charge_1yr"],
        repairWithPartRepChargeIndoor:
            json["repair_with_part_rep_charge_indoor"] == null
                ? null
                : json["repair_with_part_rep_charge_indoor"],
        checkingAdjChargeIndoor: json["checking_adj_charge_indoor"] == null
            ? null
            : json["checking_adj_charge_indoor"],
        checkingAdjChargeOutdoor: json["checking_adj_charge_outdoor"] == null
            ? null
            : json["checking_adj_charge_outdoor"],
        repairWithPartRepChargeOutdoor:
            json["repair_with_part_rep_charge_outdoor"] == null
                ? null
                : json["repair_with_part_rep_charge_outdoor"],
        grrCharge: json["grr_charge"] == null ? null : json["grr_charge"],
        transportChargeLess50Km: json["transport_charge_less_50km"] == null
            ? null
            : json["transport_charge_less_50km"],
        transportChargeBetween50Km100Km:
            json["transport_charge_between_50km_100km"] == null
                ? null
                : json["transport_charge_between_50km_100km"],
        transportChargeGreater100Km:
            json["transport_charge_greater_100km"] == null
                ? null
                : json["transport_charge_greater_100km"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId == null ? null : productId,
        "product_group_id": productGroupId == null ? null : productGroupId,
        "product_model_id": productModelId == null ? null : productModelId,
        "warranty_id": warrantyId == null ? null : warrantyId,
        "product_code": productCode == null ? null : productCode,
        "product_description":
            productDescription == null ? null : productDescription,
        "inserted_at":
            insertedAt == null ? null : insertedAt!.toIso8601String(),
        "updated_at": updatedAt,
        "product_group": productGroup == null ? null : productGroup,
        "product_group_description":
            productGroupDescription == null ? null : productGroupDescription,
        "product_model": productModel == null ? null : productModel,
        "model_description": modelDescription == null ? null : modelDescription,
        "map_to_product_code":
            mapToProductCode == null ? null : mapToProductCode,
        "is_active": isActive == null ? null : isActive,
        "specific_warranty": specificWarranty,
        "drop_in": dropIn == null ? null : dropIn,
        "home_visit": homeVisit == null ? null : homeVisit,
        "pick_up": pickUp == null ? null : pickUp,
        "service_hours": serviceHours == null ? null : serviceHours,
        "technician_service_group":
            technicianServiceGroup == null ? null : technicianServiceGroup,
        "rcp": rcp == null ? null : rcp,
        "extended_warranty_charge_1yr": extendedWarrantyCharge1Yr == null
            ? null
            : extendedWarrantyCharge1Yr,
        "repair_with_part_rep_charge_indoor":
            repairWithPartRepChargeIndoor == null
                ? null
                : repairWithPartRepChargeIndoor,
        "checking_adj_charge_indoor":
            checkingAdjChargeIndoor == null ? null : checkingAdjChargeIndoor,
        "checking_adj_charge_outdoor":
            checkingAdjChargeOutdoor == null ? null : checkingAdjChargeOutdoor,
        "repair_with_part_rep_charge_outdoor":
            repairWithPartRepChargeOutdoor == null
                ? null
                : repairWithPartRepChargeOutdoor,
        "grr_charge": grrCharge == null ? null : grrCharge,
        "transport_charge_less_50km":
            transportChargeLess50Km == null ? null : transportChargeLess50Km,
        "transport_charge_between_50km_100km":
            transportChargeBetween50Km100Km == null
                ? null
                : transportChargeBetween50Km100Km,
        "transport_charge_greater_100km": transportChargeGreater100Km == null
            ? null
            : transportChargeGreater100Km,
      };
}
