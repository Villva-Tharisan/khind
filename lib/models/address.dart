class Address {
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? cityId;
  String? postcode;
  String? state;
  String? stateId;
  String? fullAddress;

  Address({
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.cityId,
    this.postcode,
    this.stateId,
    this.state,
  });

  Address.fromJson(Map<String, dynamic> json) {
    this.addressLine1 = json["addressLine1"];
    this.addressLine2 = json["addressLine2"];
    this.city = json["city"];
    this.postcode = json["postcode"];
    this.state = json["state"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["addressLine1"] = this.addressLine1;
    data["addressLine2"] = this.addressLine2;
    data["city"] = this.city;
    data["postcode"] = this.postcode;
    data["state"] = this.state;
    return data;
  }
}
