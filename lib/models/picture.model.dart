import 'dart:core';

class Picture {
  String id;
  int createdAt;
  String filename;
  String spotId;
  String userId;
  bool allowed;

  Picture(String id, int createdAt, String filename, String spotId,
      String userId, bool allowed) {
    this.id = id;
    this.createdAt = createdAt;
    this.filename = filename;
    this.spotId = spotId;
    this.userId = userId;
    this.allowed = allowed;
  }

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(json['id'], json['createdAt'], json['filename'],
        json['spotId'], json['userId'], json['allowed']);
  }

  static List<Picture> fromJsonList(List<dynamic> json) {
    List<Picture> pictures =
        List<Picture>.from(json.map((j) => Picture.fromJson(j)));
    return pictures;
  }

  String getThumbnail() {
    return 'thumbnail_${this.id}';
  }
}
