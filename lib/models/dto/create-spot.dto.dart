import 'dart:convert';
import 'dart:core';

class CreateSpot {
  String name;
  double longitude;
  double latitude;
  String user;

  CreateSpot(String name, double longitude, double latitude, String user) {
    this.name = name;
    this.longitude = longitude;
    this.latitude = latitude;
    this.user = user;
  }

  String toDto() {
    return jsonEncode(<String, String>{
      'name': this.name,
      'longitude': this.longitude.toString(),
      'latitude': this.latitude.toString(),
      'user': this.user,
    });
  }
}
