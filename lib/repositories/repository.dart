import 'dart:io';

import 'package:spotfinder/helpers/shared-preferences.helper.dart';
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

  Future<bool> uploadPicture(File file) {
    
  }
}
