import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/models/comment.model.dart';
import 'package:spotfinder/models/dto/create-spot.dto.dart';
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

  Future<bool> createAccount(String username) async {
    User user = await RestService().createAccount(username);
    SharedPrefsHelper.instance.saveUser(user);
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> connectUserById(String id) async {
    User user = await RestService().connectUserById(id);
    SharedPrefsHelper.instance.saveUser(user);
    if (user != null) {
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

  Future<bool> uploadPicture(String idSpot, String idUser, File file) async {
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

  Future<ResultWrapper<List<Spot>>> search(String query) {
    return RestService().search(query);
  }

  // TODO: Bind real service
  Future<ResultWrapper<List<Comment>>> getPaginatedSpotComments(
      int i, int j, String id) {
    Comment comment = Comment(
        '222',
        12122121,
        'Le Lorem Ipsum est simplement du faux texte employé dans la composition et la mise en page avant impression. Le Lorem Ipsum est le faux texte standard de l\'imprimerie depuis les années 1500, quand un imprimeur anonyme assembla ensemble des morceaux de texte pour réaliser un livre spécimen de polices de texte. Il n\'a pas fait que survivre cinq siècles, mais s\'est aussi adapté à la bureautique informatique, sans que son contenu n\'en soit modifié. Il a été popularisé dans les années 1960 grâce à la vente de feuilles Letraset contenant des passages du Lorem Ipsum, et, plus récemment, par son inclusion dans des applications de mise en page de texte, comme Aldus PageMaker.',
        'userId',
        true,
        'spotId',
        'pictureId',
        'commentId',
        false);
    comment.user = User('id', 5454554, 222221, 'Rémy Lavergne', [], [],
        '8c9b2723-9c20-4869-ad41-fcb55df4c5a3');
    return Future.value(ResultWrapper(200, 212121212, [
      comment,
      comment,
      comment,
      comment,
      comment,
      comment,
      comment,
    ]));
  }
}
