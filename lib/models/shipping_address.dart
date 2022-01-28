class ShippingAddress {
  String? addressId;
  String? address1;
  String? address2;
  String? city;
  String? postcode;
  String? state;
  String? stateId;
  String? fullAddress;

  ShippingAddress({
    this.addressId,
    this.address1,
    this.address2,
    this.city,
    this.postcode,
    this.stateId,
    this.state,
  });

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    this.addressId = json["address_id"];
    this.address1 = json["address_1"];
    this.address2 = json["address_2"];
    this.city = json["city"];
    this.postcode = json["postcode"];
    this.stateId = json["zone_id"];
    this.state = json["zone"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["address_id"] = this.addressId;
    data["address_1"] = this.address1;
    data["address_1"] = this.address2;
    data["city"] = this.city;
    data["postcode"] = this.postcode;
    data["state"] = this.state;
    data["state_id"] = this.stateId;
    return data;
  }

  @override
  String toString() {
    return "{Address Id: $addressId | Address 1: $address1 | Address 2: $address2}";
  }
}
