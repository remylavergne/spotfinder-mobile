import 'dart:core';

class Spot {
  String id;
  String name;
  String address;
  String country;
  int disciplines;
  double longitude;
  double latitude;
  int creationDate;
  int modificationDate;
  bool allowed;
  String rider;

  Spot(
      String id,
      String bio,
      String name,
      String address,
      String country,
      int disciplines,
      double longitude,
      double latitude,
      int creationDate,
      int modificationDate,
      bool allowed,
      String rider) {
    this.id = id;
    this.name = name;
    this.address = address;
    this.country = country;
    this.disciplines = disciplines;
    this.longitude = longitude;
    this.latitude = latitude;
    this.creationDate = creationDate;
    this.modificationDate = modificationDate;
    this.allowed = allowed;
    this.rider = rider;
  }

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
        json['id'],
        json['bio'],
        json['name'],
        json['address'],
        json['country'],
        json['disciplines'],
        json['longitude'],
        json['latitude'],
        json['creationDate'],
        json['modificationDate'],
        json['allowed'],
        json['rider']);
  }

  static List<Spot> fromJsonList(List<dynamic> jsonSpots) {
    List<Spot> spots =
        List<Spot>.from(jsonSpots.map((jsonSpot) => Spot.fromJson(jsonSpot)));
    return spots;
  }
}
