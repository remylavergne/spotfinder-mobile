import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotfinder/helpers/common.helper.dart';

class SharedPrefsHelper {
  String _userId = 'USER_ID';

  SharedPrefsHelper._privateConstructor();

  static final SharedPrefsHelper instance =
      SharedPrefsHelper._privateConstructor();

  ///
  /// Public methods
  ///

  /// Create a unique user id if it doesn't exist
  Future<bool> createUniqueUserId() async {
    bool result = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      String id = prefs.getString(this._userId);
      if (id == null) {
        String uuid = CommonHelper.instance.generateUuidv4();
        this._setUserId(uuid);
        result = true;
      }
    } catch (e) {
      debugPrint(e);
    }

    return Future.value(result);
  }

  ///
  /// Private methods
  ///

  void _setUserId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this._userId, id);
  }
}
