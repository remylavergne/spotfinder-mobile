import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/models/comment.model.dart';
import 'package:spotfinder/models/dto/create-spot.dto.dart';
import 'package:spotfinder/models/dto/login-infos.dto.dart';
import 'package:spotfinder/models/dto/new-comment.dto.dart';
import 'package:spotfinder/models/dto/search-dto.dto.dart';
import 'package:spotfinder/models/dto/search-with-pagination.dto.dart';
import 'package:spotfinder/models/dto/update-user-profile.dto.dart';
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
    String token = await SharedPrefsHelper.instance.getToken();
    final response = await http.get(
      Constants.getBaseApi() + '/spots?page=$page&limit=$limit',
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

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
    String token = await SharedPrefsHelper.instance.getToken();
    final response = await http.post(
        Constants.getBaseApi() + '/spots/nearest?page=$page&limit=$limit',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
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
    String token = await SharedPrefsHelper.instance.getToken();
    final response = await http.get(
      Constants.getBaseApi() + '/spot/$spotID/pictures?page=$page&limit=$limit',
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> wrapperMap = jsonDecode(response.body);
      return ResultWrapper.fromJsonMap<Picture>(wrapperMap);
    } else {
      throw Exception('Failed to get paginated spots');
    }
  }

  Future<String> createSpot(CreateSpot s) async {
    String token = await SharedPrefsHelper.instance.getToken();
    final response = await http.post(Constants.getBaseApi() + '/spot/create',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        body: s.toDto());

    if (response.statusCode == 200) {
      Map<String, dynamic> spotJson = jsonDecode(response.body);
      Spot createdSpot = Spot.fromJson(spotJson);

      return Future.value(createdSpot.id);
    } else {
      return Future.value(null);
    }
  }

  Future<LoginInfos> createAccount(String username) async {
    final response = await http.post(Constants.getBaseApi() + '/user/create',
        body: username);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      LoginInfos infos = LoginInfos.fromJson(data);
      return infos;
    } else {
      return null;
    }
  }

  Future<LoginInfos> connectUserByCredentials(
      String username, String password) async {
    Response response = await http.post(
        Constants.getBaseApi() + '/user/retrieve-account',
        body: jsonEncode({'username': username, 'password': password}));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      LoginInfos infos = LoginInfos.fromJson(data);
      return infos;
    } else {
      return null;
    }
  }

  Future<Picture> uploadPicture(String idSpot, String idUser, File file) async {
    String token = await SharedPrefsHelper.instance.getToken();
    MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse(Constants.getBaseApi() + '/upload/picture'));
    // Add MultiPart data
    request.files.add(await http.MultipartFile.fromPath('picture', file.path));
    request.fields['spotId'] = idSpot;
    request.fields['userId'] = idUser;
    request.headers.addAll({HttpHeaders.authorizationHeader: 'Bearer $token'});

    var responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);

    if (response.statusCode == 200) {
      Map<String, dynamic> pictureMap = jsonDecode(response.body);
      Picture picture = Picture.fromJson(pictureMap);
      return Future.value(picture);
    } else {
      return Future.value(null);
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
    String token = await SharedPrefsHelper.instance.getToken();
    final response = await http.get(
      Constants.getBaseApi() + '/spot/$spotId/comments?page=$page&limit=$limit',
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> wrapperMap = jsonDecode(response.body);
      return ResultWrapper.fromJsonMap<Comment>(wrapperMap)
          as ResultWrapper<List<Comment>>;
    } else {
      throw Exception('Failed to get paginated spots');
    }
  }

  Future<bool> addComment(NewCommentDto comment) async {
    String token = await SharedPrefsHelper.instance.getToken();
    Response response = await http.post(
        Constants.getBaseApi() + '/comment/create',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        body: comment.toJson());

    if (response.statusCode == 200) {
      return true;
    } else {
      return null;
    }
  }

  Future<User> getUserById(String id) async {
    String token = await SharedPrefsHelper.instance.getToken();
    final response = await http.post(Constants.getBaseApi() + '/user',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}, body: id);

    if (response.statusCode == 200) {
      Map<String, dynamic> userMap = jsonDecode(response.body);
      return Future.value(User.fromJson(userMap));
    } else {
      throw Exception('Failed to get user by id');
    }
  }

  Future<ResultWrapper<List<Picture>>> getUserPictures(
      SearchWithPagination query) async {
    String token = await SharedPrefsHelper.instance.getToken();
    final response = await http.post(Constants.getBaseApi() + '/user/pictures',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        body: query.toJson());

    if (response.statusCode == 200) {
      Map<String, dynamic> wrapperMap = jsonDecode(response.body);
      return ResultWrapper.fromJsonMap<Picture>(wrapperMap);
    } else {
      throw Exception('Failed to get user pictures');
    }
  }

  Future<ResultWrapper<List<Comment>>> getUserComments(
      SearchWithPagination query) async {
    String token = await SharedPrefsHelper.instance.getToken();
    final response = await http.post(Constants.getBaseApi() + '/user/comments',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        body: query.toJson());

    if (response.statusCode == 200) {
      Map<String, dynamic> wrapperMap = jsonDecode(response.body);
      return ResultWrapper.fromJsonMap<Comment>(wrapperMap);
    } else {
      throw Exception('Failed to get user pictures');
    }
  }

  Future<ResultWrapper<List<Spot>>> getUserSpots(
      SearchWithPagination searchWithPagination) async {
    String token = await SharedPrefsHelper.instance.getToken();
    final response = await http.post(Constants.getBaseApi() + '/user/spots',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        body: searchWithPagination.toJson());

    if (response.statusCode == 200) {
      Map<String, dynamic> wrapperMap = jsonDecode(response.body);
      return ResultWrapper.fromJsonMap<Spot>(wrapperMap);
    } else {
      throw Exception('Failed to get user spots');
    }
  }

  Future<ResultWrapper<List<Spot>>> getUserPendingSpots(
      SearchWithPagination searchWithPagination) async {
    String token = await SharedPrefsHelper.instance.getToken();
    final response = await http.post(
        Constants.getBaseApi() + '/user/pending-spots',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        body: searchWithPagination.toJson());

    if (response.statusCode == 200) {
      Map<String, dynamic> wrapperMap = jsonDecode(response.body);
      return ResultWrapper.fromJsonMap<Spot>(wrapperMap);
    } else {
      throw Exception('Failed to get user pending spots');
    }
  }

  Future<User> updateUserProfile(UpdateUserProfile data) async {
    String token = await SharedPrefsHelper.instance.getToken();
    final response = await http.put(
        Constants.getBaseApi() + '/user/update-profile',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        body: data.toJson());

    if (response.statusCode == 200) {
      Map<String, dynamic> userMap = jsonDecode(response.body);
      return User.fromJson(userMap);
    } else {
      throw Exception('Failed to get user pictures');
    }
  }
}
