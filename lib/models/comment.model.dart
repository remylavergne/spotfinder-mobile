import 'package:spotfinder/models/dto/new-comment.dto.dart';
import 'package:spotfinder/models/user.model.dart';

class Comment {
  String id;
  int createdAt;
  String message;
  String userId;
  bool allowed;
  String spotId;
  String pictureId;
  String commentId;
  bool child;
  User user;

  Comment(
      String id,
      int createdAt,
      String message,
      String userId,
      bool allowed,
      String spotId,
      String pictureId,
      String commentId,
      bool child,
      User user) {
    this.id = id;
    this.createdAt = createdAt;
    this.message = message;
    this.userId = userId;
    this.allowed = allowed;
    this.spotId = spotId;
    this.pictureId = pictureId;
    this.commentId = commentId;
    this.child = child;
    this.user = user;
  }

  static Comment fromJson(Map<String, dynamic> json) {
    return Comment(
        json['id'],
        json['createdAt'],
        json['message'],
        json['userId'],
        json['allowed'],
        json['spotId'],
        json['pictureId'],
        json['commentId'],
        json['child'],
        User.fromJson(json['user'][0]));
  }

  static List<Comment> fromJsonList(List<dynamic> json) {
    List<Comment> comments =
        List<Comment>.from(json.map((j) => Comment.fromJson(j)));
    return comments;
  }

  static NewCommentDto toNewCommentDto(String message, String userId,
      String spotId, String pictureId, String commentId) {
    return NewCommentDto(message, userId, spotId, pictureId, commentId);
  }
}
