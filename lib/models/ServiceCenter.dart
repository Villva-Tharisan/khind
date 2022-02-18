class ServiceCenter {
  String? serviceCenterId;
  String? serviceCenterTypeId;
  String? serviceCenterName;
  String? operatingHours;
  String? address;
  String? telephone;
  String? stateId;
  String? cityId;

  ServiceCenter(
      {this.serviceCenterId,
      this.serviceCenterTypeId,
      this.serviceCenterName,
      this.operatingHours,
      this.address,
      this.telephone,
      this.stateId,
      this.cityId});

  ServiceCenter.fromJson(Map<String, dynamic> json) {
    this.serviceCenterId = json["service_center_id"];
    this.serviceCenterTypeId = json["service_center_type_id"];
    this.serviceCenterName = json["service_center_name"];
    this.operatingHours = json["operating_hours"];
    this.address = json["address"];
    this.telephone = json["telephone"];
    this.stateId = json["state_id"];
    this.cityId = json["city_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["service_center_id"] = this.serviceCenterId;
    data["service_center_type_id"] = this.serviceCenterTypeId;
    data["service_center_name"] = this.serviceCenterName;
    data["operating_hours"] = this.operatingHours;
    data["address"] = this.address;
    data["telephone"] = this.telephone;
    data["state_id"] = this.stateId;
    data["city_id"] = this.cityId;
    return data;
  }
}
