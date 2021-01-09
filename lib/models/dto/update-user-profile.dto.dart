import 'dart:convert';

class UpdateUserProfile {
  String userId;
  String pictureId;

  UpdateUserProfile(String userId, String pictureId) {
    this.userId = userId;
    this.pictureId = pictureId;
  }

  String toJson() {
    return jsonEncode(
        <String, String>{'userId': this.userId, 'pictureId': this.pictureId});
  }
}
