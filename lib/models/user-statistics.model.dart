import 'dart:core';

class UserStatistics {
  String id;
  int spots;
  int pictures;
  int comments;
  int likes;

  UserStatistics(String id, int spots, int pictures, int comments, int likes) {
    this.id = id;
    this.spots = spots;
    this.pictures = pictures;
    this.comments = comments;
    this.likes = likes;
  }

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(json['id'], json['spots'], json['pictures'],
        json['comments'], json['likes']);
  }
}
