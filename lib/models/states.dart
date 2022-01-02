class States {
  String? stateId;
  String? countryId;
  String? stateCode;
  String? state;
  String? insertedAt;
  dynamic? updatedAt;

  States(
      {this.stateId, this.countryId, this.stateCode, this.state, this.insertedAt, this.updatedAt});

  States.fromJson(Map<String, dynamic> json) {
    this.stateId = json["state_id"];
    this.countryId = json["country_id"];
    this.stateCode = json["state_code"];
    this.state = json["state"];
    this.insertedAt = json["inserted_at"];
    this.updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["state_id"] = this.stateId;
    data["country_id"] = this.countryId;
    data["state_code"] = this.stateCode;
    data["state"] = this.state;
    data["inserted_at"] = this.insertedAt;
    data["updated_at"] = this.updatedAt;
    return data;
  }
}
