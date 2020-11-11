import 'dart:core';

class User {
  String id;
  int createdAt;
  int lastConnexion;
  String username;
  List<String> spots;
  List<String> pictures;

  User(String id, int createdAt, int lastConnexion, String username,
      List<String> spots, List<String> pictures) {
    this.id = id;
    this.createdAt = createdAt;
    this.lastConnexion = lastConnexion;
    this.username = username;
    this.spots = spots;
    this.pictures = List<String>.from(pictures);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        json['id'],
        json['createdAt'],
        json['lastConnexion'],
        json['username'],
        List<String>.from(json['spots']),
        List<String>.from(json['pictures']));
  }
}
