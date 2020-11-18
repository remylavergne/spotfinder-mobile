import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/models/dto/create-spot.dto.dart';
import 'package:spotfinder/models/pagination.model.dart';
import 'package:spotfinder/models/picture.model.dart';
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
      ResultWrapper<List<Spot>> rw = ResultWrapper.fromJson(wrapperMap, spots);
      rw.pagination = pagination;

      return rw;
    } else {
      throw Exception('Failed to get paginated spots');
    }
  }

  Future<ResultWrapper<List<Picture>>> getPaginatedPictures(
      int page, int limit, String spotID) async {
    final response = await http.get(Constants.getBaseApi() +
        '/spot/$spotID/pictures?page=$page&limit=$limit');

    if (response.statusCode == 200) {
      Map<String, dynamic> wrapperMap = jsonDecode(response.body);
      // Serialize Spots objects
      List<dynamic> picturesJson = wrapperMap['result'];
      List<Picture> pictures = Picture.fromJsonList(picturesJson);
      // Serialize Pagination
      Map<String, dynamic> paginationJson = wrapperMap['pagination'];
      Pagination pagination = Pagination.fromJson(paginationJson);
      // Création du ResultWrapper
      ResultWrapper<List<Picture>> rw =
          ResultWrapper.fromJson(wrapperMap, pictures);
      rw.pagination = pagination;

      return rw;
    } else {
      throw Exception('Failed to get paginated spots');
    }
  }

  Future<String> createSpot(CreateSpot s) async {
    final response = await http.post(Constants.getBaseApi() + '/spot/create',
        body: s.toDto());

    if (response.statusCode == 200) {
      Map<String, dynamic> spotJson = jsonDecode(response.body);
      Spot createdSpot = Spot.fromJson(spotJson);

      return Future.value(createdSpot.id);
    } else {
      return Future.value(null);
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
    Response response =
        await http.post(Constants.getBaseApi() + '/user/connect', body: id);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      User user = User.fromJson(data);
      return user;
    } else {
      return null;
    }
  }

  Future<bool> uploadPicture(String idSpot, String idUser, File file) async {
    MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse(Constants.getBaseApi() + '/upload/picture'));
    // Add MultiPart data
    request.files.add(await http.MultipartFile.fromPath('picture', file.path));
    request.fields['spotId'] = idSpot;
    request.fields['userId'] = idUser;

    var response = await request.send();

    if (response.statusCode == 200) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }
}
