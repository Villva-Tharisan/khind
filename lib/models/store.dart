// To parse this JSON data, do
//
//     final store = storeFromJson(jsonString);

import 'dart:convert';

Store storeFromJson(String str) => Store.fromJson(json.decode(str));

String storeToJson(Store data) => json.encode(data.toJson());

class Store {
  Store({
    this.data,
  });

  List<Datum>? data;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
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
    this.storeId,
    this.storeName,
    this.bpStatus,
    this.insertedAt,
    this.updatedAt,
  });

  String? storeId;
  String? storeName;
  String? bpStatus;
  DateTime? insertedAt;
  DateTime? updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        storeId: json["store_id"] == null ? null : json["store_id"],
        storeName: json["store_name"] == null ? null : json["store_name"],
        bpStatus: json["bp_status"] == null ? null : json["bp_status"],
        insertedAt: json["inserted_at"] == null
            ? null
            : DateTime.parse(json["inserted_at"]),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId == null ? null : storeId,
        "store_name": storeName == null ? null : storeName,
        "bp_status": bpStatus == null ? null : bpStatus,
        "inserted_at":
            insertedAt == null ? null : insertedAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : insertedAt!.toIso8601String(),
      };
}
