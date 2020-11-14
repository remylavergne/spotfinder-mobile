import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/models/dto/create-spot.dto.dart';
import 'package:spotfinder/models/mocks/spot.mocks.dart';
import 'package:spotfinder/models/pagination.model.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/models/spot.model.dart';
import 'package:spotfinder/models/user.model.dart';

class RestService {
  RestService._privateConstructor();

  static final RestService _instance = RestService._privateConstructor();

  factory RestService() {
    return _instance;
  }

  Future<ResultWrapper<List<Spot>>> getPaginatedSpots(
      int page, int limit) async {
    final response = await http
        .get(Constants.getBaseApi() + '/spots?page=$page&limit=$limit');

    if (response.statusCode == 200) {
      Map<String, dynamic> wrapperMap = jsonDecode(response.body);
      // Serialize Spots objects
      List<dynamic> spotsJson = wrapperMap['result'];
      List<Spot> spots = Spot.fromJsonList(spotsJson);
      // Serialize Pagination
      Map<String, dynamic> paginationJson = wrapperMap['pagination'];
      Pagination pagination = Pagination.fromJson(paginationJson);
      // Création du ResultWrapper
      ResultWrapper rw = ResultWrapper.fromJson(wrapperMap, spots);
      rw.pagination = pagination;

      return rw;
    } else {
      throw Exception('Failed to get paginated spots');
    }
  }

  Future<bool> createSpot(CreateSpot s) async {
    final response = await http.post(Constants.getBaseApi() + '/spot/create',
        body: s.toString());

    if (response.statusCode == 200) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  Future<User> createAccount(String username) async {
    final response = await http.post(Constants.getBaseApi() + '/user/create',
        body: username);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      User user = User.fromJson(data);
      return user;
    } else {
      return null;
    }
  }

  Future<User> connectUserById(String id) async {
    final response =
        await http.post(Constants.getBaseApi() + '/user/connect', body: id);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      User user = User.fromJson(data);
      return user;
    } else {
      return null;
    }
  }
}
