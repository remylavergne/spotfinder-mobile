import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/models/comment.model.dart';
import 'package:spotfinder/models/dto/create-spot.dto.dart';
import 'package:spotfinder/models/dto/new-account.dto.dart';
import 'package:spotfinder/models/dto/search-dto.dto.dart';
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
      return ResultWrapper.fromJsonMap<Spot>(wrapperMap)
          as ResultWrapper<List<Spot>>;
    } else {
      throw Exception('Failed to get paginated spots');
    }
  }

  Future<ResultWrapper<List<Spot>>> getNearestPaginatedSpots(
      Position position, int page, int limit) async {
    final response = await http.post(
        Constants.getBaseApi() + '/spots/nearest?page=$page&limit=$limit',
        body: jsonEncode(
            {"longitude": position.longitude, "latitude": position.latitude}));

    if (response.statusCode == 200) {
      Map<String, dynamic> wrapperMap = jsonDecode(response.body);
      return ResultWrapper.fromJsonMap<Spot>(wrapperMap);
    } else {
      throw Exception('Failed to get nearest paginated spots');
    }
  }

  Future<ResultWrapper<List<Picture>>> getPaginatedSpotPictures(
      int page, int limit, String spotID) async {
    final response = await http.get(Constants.getBaseApi() +
        '/spot/$spotID/pictures?page=$page&limit=$limit');

    if (response.statusCode == 200) {
      Map<String, dynamic> wrapperMap = jsonDecode(response.body);
      return ResultWrapper.fromJsonMap<Picture>(wrapperMap);
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

  Future<User> connectUserByCredentials(String username, String password) async {
    Response response = await http.post(
        Constants.getBaseApi() + '/user/retrieve-account',
        body: jsonEncode({'username': username, 'password': password}));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      NewAccount newAccount = NewAccount.fromJson(data);
      User user = User.fromNewAccount(newAccount);
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

  Future<ResultWrapper<List<Spot>>> search(String query) async {
    String token = await SharedPrefsHelper.instance.getToken();
    final response = await http.post(Constants.getBaseApi() + '/search',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        body: SearchDto(query).toDto());

    if (response.statusCode == 200) {
      Map<String, dynamic> wrapperMap = jsonDecode(response.body);
      return ResultWrapper.fromJsonMap<Spot>(wrapperMap);
    } else {
      return Future.value(null);
    }
  }

  Future<ResultWrapper<List<Comment>>> getPaginatedSpotComments(
      String spotId, int page, int limit) async {
    final response = await http.get(Constants.getBaseApi() +
        '/spot/$spotId/comments?page=$page&limit=$limit');

    if (response.statusCode == 200) {
      Map<String, dynamic> wrapperMap = jsonDecode(response.body);
      return ResultWrapper.fromJsonMap<Comment>(wrapperMap)
          as ResultWrapper<List<Comment>>;
    } else {
      throw Exception('Failed to get paginated spots');
    }
  }
}
