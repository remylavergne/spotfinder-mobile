import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/models/mocks/spot.mocks.dart';
import 'package:spotfinder/models/spot.model.dart';

class RestService {
  RestService._privateConstructor();

  static final RestService _instance = RestService._privateConstructor();

  factory RestService() {
    return _instance;
  }

  Future<List<Spot>> getSpots() async {
    if (Constants.mockEnabled) {
      return Future.value(SpotMocks.getSpots());
    } else {
      final response = await http.get(Constants.getBaseApi() + '');

      if (response.statusCode == 200) {
        final jsonSpots = jsonDecode(response.body);
        final spots = List<Spot>.from(
            jsonSpots.map((jsonSpot) => Spot.fromJson(jsonSpot)));

        debugPrint(spots[0].bio);
        return Future.value(spots);
      } else {
        throw Exception('Failed to get spots');
      }
    }
  }
}
