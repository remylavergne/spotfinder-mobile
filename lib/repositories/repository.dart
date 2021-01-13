import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:spotfinder/enums/comments-type.enum.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/models/comment.model.dart';
import 'package:spotfinder/models/dto/create-spot.dto.dart';
import 'package:spotfinder/models/dto/login-infos.dto.dart';
import 'package:spotfinder/models/dto/new-comment.dto.dart';
import 'package:spotfinder/models/dto/search-with-pagination.dto.dart';
import 'package:spotfinder/models/dto/update-user-profile.dto.dart';
import 'package:spotfinder/models/picture.model.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/models/spot.model.dart';
import 'package:spotfinder/models/user.model.dart';
import 'package:spotfinder/services/global-rest.service.dart';

class Repository {
  Repository._privateConstructor();

  static final Repository _instance = Repository._privateConstructor();

  factory Repository() {
    return _instance;
  }

  Future<LoginInfos> createAccount(String username) async {
    LoginInfos infos = await RestService().createAccount(username);
    SharedPrefsHelper.instance.saveUserInfos(infos);
    return Future.value(infos);
  }

  Future<bool> connectUserByCredentials(
      String username, String password) async {
    LoginInfos infos =
        await RestService().connectUserByCredentials(username, password);
    SharedPrefsHelper.instance.saveUserInfos(infos);
    if (infos != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Spot>> getSpots() {
    return null;
  }

  Future<ResultWrapper<List<Spot>>> getPaginatedSpots(int page, int limit) {
    return RestService().getPaginatedSpots(page, limit);
  }

  Future<String> createSpot(Position position, String name) async {
    String id = await SharedPrefsHelper.instance.getId();
    CreateSpot newSpot =
        new CreateSpot(name, position.longitude, position.latitude, id);

    String idSpot = await RestService().createSpot(newSpot);

    return idSpot;
  }

  Future<Picture> uploadPicture(String idSpot, String idUser, File file) async {
    return await RestService().uploadPicture(idSpot, idUser, file);
  }

  Future<ResultWrapper<List<Spot>>> getNearestPaginatedSpots(
      Position position, int page, int limit) {
    return RestService().getNearestPaginatedSpots(position, page, limit);
  }

  Future<ResultWrapper<List<Picture>>> getPaginatedSpotPictures(
      int page, int limit, String spotID) async {
    return RestService().getPaginatedSpotPictures(page, limit, spotID);
  }

  Future<ResultWrapper<List<Picture>>> getPendingPicturesBySpotId(
      int page, int limit, String spotId) async {
    return RestService().getPendingPicturesBySpotId(page, limit, spotId);
  }

  Future<List<ResultWrapper<List<Spot>>>> getNewestSpotsWithUserPendingSpots(
      SearchWithPagination searchWithPagination, int page, int limit) {
    // Calls
    Future<ResultWrapper<List<Spot>>> newestSpots =
        RestService().getPaginatedSpots(page, limit);
    Future<ResultWrapper<List<Spot>>> pending =
        RestService().getUserPendingSpots(searchWithPagination);
    return Future.wait([pending, newestSpots]);
  }

  Future<ResultWrapper<List<Spot>>> getUserSpotsWithPending(
      SearchWithPagination searchWithPagination, int page, int limit) {
    return RestService()
        .getUserSpotsWithPending(searchWithPagination, page, limit);
  }

  Future<ResultWrapper<List<Spot>>> search(String query) {
    return RestService().search(query);
  }

  Future<ResultWrapper<List<Comment>>> getPaginatedSpotComments(
      int page, int limit, String spotId) {
    return RestService().getPaginatedSpotComments(spotId, page, limit);
  }

  Future<bool> sendComment(
      String message, CommentType commentType, String id) async {
    // Get user id
    String currentUserId = await SharedPrefsHelper.instance.getId();
    // Build Comment
    NewCommentDto comment;
    switch (commentType) {
      case CommentType.SPOT:
        comment = NewCommentDto(message, currentUserId, id, null, null);
        break;
      case CommentType.PICTURE:
        // TODO: Future version
        break;
      case CommentType.COMMENT:
        // TODO: Future version
        break;
      default:
    }
    // Send it
    bool added = await RestService().addComment(comment);

    return Future.value(added);
  }

  Future<User> getUserById(String id) {
    return RestService().getUserById(id);
  }

  Future<ResultWrapper<List<Picture>>> getUserPictures(
      SearchWithPagination query) {
    return RestService().getUserPictures(query);
  }

  Future<ResultWrapper<List<Picture>>> getUserPicturesWithPending(
      SearchWithPagination query) {
    return RestService().getUserPicturesWithPending(query);
  }

  Future<ResultWrapper<List<Comment>>> getUserComments(
      SearchWithPagination query) {
    return RestService().getUserComments(query);
  }

  Future<ResultWrapper<List<Spot>>> getUserSpots(
      SearchWithPagination searchWithPagination) {
    return RestService().getUserSpots(searchWithPagination);
  }

  Future<ResultWrapper<List<Spot>>> getUserPendingSpots(
      SearchWithPagination searchWithPagination) {
    return RestService().getUserPendingSpots(searchWithPagination);
  }

  Future<User> updateUserProfile(UpdateUserProfile data) {
    return RestService().updateUserProfile(data);
  }
}
