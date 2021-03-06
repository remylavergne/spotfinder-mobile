import 'dart:core';

import 'package:spotfinder/models/user.model.dart';

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

  static Picture fromUser(User user) {
    return new Picture(user.pictureId, DateTime.now().millisecondsSinceEpoch,
        null, null, user.id, true);
  }

  String getThumbnail() {
    return 'thumbnail_${this.id}';
  }
}
