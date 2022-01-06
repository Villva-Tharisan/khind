class User {
  String? id;
  late String name;
  String? mobile;
  String? email;
  String? address;
  String? dob;

  User({required this.id, required this.name, this.mobile, this.email, this.address, this.dob});

  User.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.name = json["name"];
    this.mobile = json["mobile"];
    this.email = json["email"];
    this.address = json["address"];
    this.dob = json["dob"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["name"] = this.name;
    data["mobile"] = this.mobile;
    data["email"] = this.email;
    data["address"] = this.address;
    return data;
  }
}
