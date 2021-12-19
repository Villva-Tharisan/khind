class New {
  int? id;
  int? userId;
  int? categoryId;
  String? coverImg;
  String? thumbnail;
  String? title;
  int? viewCount;
  String? updatedAt;
  String? createdAt;
  String? publishedAt;
  int? status;
  int? publishStatus;
  int? commentsCount;
  List<Tags>? tags;
  Category? category;
  String? pdfFile;

  New(
      {this.id,
      this.userId,
      this.categoryId,
      this.coverImg,
      this.thumbnail,
      this.title,
      this.viewCount,
      this.updatedAt,
      this.createdAt,
      this.publishedAt,
      this.status,
      this.publishStatus,
      this.commentsCount,
      this.tags,
      this.category,
      this.pdfFile});

  New.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.userId = json["user_id"];
    this.categoryId = json["category_id"];
    this.coverImg = json["cover_img"];
    this.thumbnail = json["thumbnail"];
    this.title = json["title"];
    this.viewCount = json["view_count"];
    this.updatedAt = json["updated_at"];
    this.createdAt = json["created_at"];
    this.publishedAt = json["published_at"];
    this.status = json["status"];
    this.publishStatus = json["publish_status"];
    this.commentsCount = json["comments_count"];
    this.tags = json["tags"] == null
        ? null
        : (json["tags"] as List).map((e) => Tags.fromJson(e)).toList();
    this.category =
        json["category"] == null ? null : Category.fromJson(json["category"]);
    this.pdfFile = json["pdf_file"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["user_id"] = this.userId;
    data["category_id"] = this.categoryId;
    data["cover_img"] = this.coverImg;
    data["thumbnail"] = this.thumbnail;
    data["title"] = this.title;
    data["view_count"] = this.viewCount;
    data["updated_at"] = this.updatedAt;
    data["created_at"] = this.createdAt;
    data["published_at"] = this.publishedAt;
    data["status"] = this.status;
    data["publish_status"] = this.publishStatus;
    data["comments_count"] = this.commentsCount;
    if (this.tags != null)
      data["tags"] = this.tags?.map((e) => e.toJson()).toList();
    if (this.category != null) data["category"] = this.category?.toJson();
    data["pdf_file"] = this.pdfFile;
    return data;
  }
}

class Category {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? name;
  dynamic? coverImg;
  dynamic? description;

  Category(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.coverImg,
      this.description});

  Category.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.createdAt = json["created_at"];
    this.updatedAt = json["updated_at"];
    this.name = json["name"];
    this.coverImg = json["cover_img"];
    this.description = json["description"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["created_at"] = this.createdAt;
    data["updated_at"] = this.updatedAt;
    data["name"] = this.name;
    data["cover_img"] = this.coverImg;
    data["description"] = this.description;
    return data;
  }
}

class Tags {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? name;
  Pivot? pivot;

  Tags({this.id, this.createdAt, this.updatedAt, this.name, this.pivot});

  Tags.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.createdAt = json["created_at"];
    this.updatedAt = json["updated_at"];
    this.name = json["name"];
    this.pivot = json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["created_at"] = this.createdAt;
    data["updated_at"] = this.updatedAt;
    data["name"] = this.name;
    if (this.pivot != null) data["pivot"] = this.pivot?.toJson();
    return data;
  }
}

class Pivot {
  int? postId;
  int? tagId;

  Pivot({this.postId, this.tagId});

  Pivot.fromJson(Map<String, dynamic> json) {
    this.postId = json["post_id"];
    this.tagId = json["tag_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["post_id"] = this.postId;
    data["tag_id"] = this.tagId;
    return data;
  }
}
