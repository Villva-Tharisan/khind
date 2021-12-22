class City {
  String? stateId;
  String? city;
  String? cityId;
  String? postcodeId;
  String? postcode;

  City({this.stateId, this.city, this.cityId, this.postcodeId, this.postcode});

  City.fromJson(Map<String, dynamic> json) {
    this.stateId = json["state_id"];
    this.city = json["city"];
    this.cityId = json["city_id"];
    this.postcodeId = json["postcode_id"];
    this.postcode = json["postcode"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["state_id"] = this.stateId;
    data["city"] = this.city;
    data["city_id"] = this.cityId;
    data["postcode_id"] = this.postcodeId;
    data["postcode"] = this.postcode;
    return data;
  }
}
