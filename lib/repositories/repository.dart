import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/models/dto/create-spot.dto.dart';
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
}
