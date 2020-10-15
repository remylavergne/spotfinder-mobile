import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/models/mocks/spot.mocks.dart';
import 'package:spotfinder/models/spot.model.dart';
import 'package:spotfinder/services/spot-rest.service.dart';

class RestService implements SpotService {
  RestService._privateConstructor();

  static final RestService _instance = RestService._privateConstructor();

  factory RestService() {
    return _instance;
  }

  @override
  Future<List<Spot>> getSpots() async {
    if (Constants.mockEnabled) {
      return Future.value(SpotMocks.getSpots());
    } else {
      final response = await http.get(Constants.getBaseApi() + '/spot/all');

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

  @override
  Future<void> createNewSpot(Spot s) {
    // TODO: implement createNewSpot
    throw UnimplementedError();
  }

  @override
  Future<Spot> getSpotById(String id) {
    // TODO: implement getSpotById
    throw UnimplementedError();
  }

  @override
  Future<List<Spot>> getSpotsByRider(String id) {
    // TODO: implement getSpotsByRider
    throw UnimplementedError();
  }
}
