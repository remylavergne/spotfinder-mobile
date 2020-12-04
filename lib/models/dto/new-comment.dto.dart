import 'dart:convert';

class NewCommentDto {
  String message;
  String userId;
  String spotId;
  String pictureId;
  String commentId;

  NewCommentDto(String message, String userId, String spotId, String pictureId,
      String commentId) {
    this.message = message;
    this.userId = userId;
    this.spotId = spotId;
    this.pictureId = pictureId;
    this.commentId = commentId;
  }

  String toJson() {
    return jsonEncode(<String, String>{
      'message': this.message,
      'userId': this.userId,
      'spotId': this.spotId,
      'pictureId': this.pictureId,
      'commentId': this.commentId
    });
  }
}
