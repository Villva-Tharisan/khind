class Postcodes {
  String? postcodeId;
  String? cityId;
  String? postcode;
  String? insertedAt;
  dynamic? updatedAt;
  String? stateId;
  String? cityCode;
  String? city;

  Postcodes(
      {this.postcodeId,
      this.cityId,
      this.postcode,
      this.insertedAt,
      this.updatedAt,
      this.stateId,
      this.cityCode,
      this.city});

  Postcodes.fromJson(Map<String, dynamic> json) {
    this.postcodeId = json["postcode_id"];
    this.cityId = json["city_id"];
    this.postcode = json["postcode"];
    this.insertedAt = json["inserted_at"];
    this.updatedAt = json["updated_at"];
    this.stateId = json["state_id"];
    this.cityCode = json["city_code"];
    this.city = json["city"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["postcode_id"] = this.postcodeId;
    data["city_id"] = this.cityId;
    data["postcode"] = this.postcode;
    data["inserted_at"] = this.insertedAt;
    data["updated_at"] = this.updatedAt;
    data["state_id"] = this.stateId;
    data["city_code"] = this.cityCode;
    data["city"] = this.city;
    return data;
  }
}
