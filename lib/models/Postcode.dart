class Postcode {
  String? id;
  String? postcode;

  Postcode({required this.id, this.postcode});

  Postcode.fromJson(Map<String, dynamic> json) {
    this.id = json["postcode_id"];
    this.postcode = json["postcode"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["postcode_id"] = this.id;
    data["postcode"] = this.postcode;
    return data;
  }
}
