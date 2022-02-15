import 'package:flutter_config/flutter_config.dart';

class Banners {
  int? id;
  String? title;
  String? description;
  String? imageUrl;
  int? postId;

  Banners({this.id, this.title, this.description, this.imageUrl, this.postId});

  Banners.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.title = json["title"];
    this.description = json["description"];
    this.imageUrl = json["image_url"] != null
        ? '${FlutterConfig.get("CMS_URL")}/${json["image_url"]}'
        : json["image_url"];
    this.postId = json["post_id"];
    ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["title"] = this.title;
    data["description"] = this.description;
    data["image_url"] = this.imageUrl;
    data["post_id"] = this.postId;
    return data;
  }
}
