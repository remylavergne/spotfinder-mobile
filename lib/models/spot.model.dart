import 'dart:core';

class Spot {
  String id;
  String name;
  String address;
  String country;
  String pictureId;
  int disciplines;
  double longitude;
  double latitude;
  int creationDate;
  int modificationDate;
  bool allowed;
  String user;

  Spot(
      String id,
      String bio,
      String name,
      String address,
      String country,
      String pictureId,
      int disciplines,
      double longitude,
      double latitude,
      int creationDate,
      int modificationDate,
      bool allowed,
      String user) {
    this.id = id;
    this.name = name;
    this.address = address;
    this.country = country;
    this.pictureId = pictureId;
    this.disciplines = disciplines;
    this.longitude = longitude;
    this.latitude = latitude;
    this.creationDate = creationDate;
    this.modificationDate = modificationDate;
    this.allowed = allowed;
    this.user = user;
  }

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
        json['id'],
        json['bio'],
        json['name'],
        json['address'],
        json['country'],
        json['pictureId'],
        json['disciplines'],
        json['longitude'],
        json['latitude'],
        json['creationDate'],
        json['modificationDate'],
        json['allowed'],
        json['user']);
  }

  static List<Spot> fromJsonList(List<dynamic> jsonSpots) {
    List<Spot> spots =
        List<Spot>.from(jsonSpots.map((jsonSpot) => Spot.fromJson(jsonSpot)));
    return spots;
  }
}
