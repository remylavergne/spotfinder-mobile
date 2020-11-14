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
    return RestService().getSpots();
  }

  Future<ResultWrapper<List<Spot>>> getPaginatedSpots(int page, int limit) {
    return RestService().getPaginatedSpots(page, limit);
  }

  Future<bool> createSpot(Position position, String name) async {
    String id = await SharedPrefsHelper.instance.getId();
    CreateSpot newSpot =
        new CreateSpot(name, position.longitude, position.latitude, id);

    bool result = await RestService().createSpot(newSpot);

    return result;
  }

  Future<bool> uploadPicture(File file) async {
    await new Future.delayed(const Duration(seconds: 3));

    return Future.value(true);
  }
}
