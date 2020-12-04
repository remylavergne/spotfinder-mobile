import 'dart:core';

import 'package:spotfinder/models/dto/login-infos.dto.dart';

class User {
  String id;
  int createdAt;
  int lastConnexion;
  String username;
  List<String> spots;
  List<String> pictures;
  String pictureId;
  String token;

  User(
      String id,
      int createdAt,
      int lastConnexion,
      String username,
      List<String> spots,
      List<String> pictures,
      String pictureId,
      String token) {
    this.id = id;
    this.createdAt = createdAt;
    this.lastConnexion = lastConnexion;
    this.username = username;
    this.spots = spots;
    this.pictures = List<String>.from(pictures);
    this.pictureId = pictureId;
    this.token = token;
  }

  static User fromLoginInfos(LoginInfos infos) {
    return User(
        infos.id,
        DateTime.now().millisecondsSinceEpoch,
        DateTime.now().millisecondsSinceEpoch,
        infos.username,
        [],
        [],
        null,
        infos.token);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        json['id'],
        json['createdAt'],
        json['lastConnexion'],
        json['username'],
        List<String>.from(json['spots']),
        List<String>.from(json['pictures']),
        json['pictureId'],
        null);
  }
}
