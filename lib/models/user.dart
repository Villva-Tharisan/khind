class User {
  dynamic? id;
  String? referreId;
  String? firstname;
  String? lastname;
  String? telephone;
  String? email;
  String? address;
  String? addressId;
  String? dob;
  String? status;
  String? approved;
  String? verifyStatus;

  User(
      {required this.id,
      this.firstname,
      this.lastname,
      this.referreId,
      this.telephone,
      this.email,
      this.address,
      this.addressId,
      this.dob,
      this.status,
      this.approved,
      this.verifyStatus});

  User.fromJson(Map<String, dynamic> json) {
    // print("#JSON: $json");
    this.id = json["customer_id"];
    this.referreId = json["referrer_id"];
    this.firstname = json["firstname"] ?? null;
    this.lastname = json["lastname"] ?? null;
    this.telephone = json["telephone"];
    this.email = json["email"];
    this.address = json["address"];
    this.addressId = json["address_id"];
    this.dob = json["dob"];
    this.status = json["status"];
    this.approved = json["approved"];
    this.verifyStatus = json["verify_status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["customer_id"] = this.id;
    data["first_name"] = this.firstname;
    data["last_name"] = this.lastname;
    data["telephone"] = this.telephone;
    data["email"] = this.email;
    data["address"] = this.address;
    data["address_id"] = this.addressId;
    data["dob"] = this.dob;
    data["status"] = this.status;
    data["approved"] = this.approved;
    data["verify_status"] = this.verifyStatus;
    return data;
  }
}
