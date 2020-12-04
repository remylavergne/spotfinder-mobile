import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotfinder/models/user.model.dart';

class SharedPrefsHelper {
  String _username = 'USERNAME';
  String _idUser = 'ID_USER';
  String _token = 'TOKEN';

  SharedPrefsHelper._privateConstructor();

  static final SharedPrefsHelper instance =
      SharedPrefsHelper._privateConstructor();

  void saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this._idUser, user.id);
    prefs.setString(this._username, user.username);
    prefs.setString(this._token, user.token);
  }

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username;
    try {
      username = prefs.getString(this._username);
    } catch (e) {
      debugPrint(e.toString());
    }
    return Future.value(username);
  }

  Future<String> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id;
    try {
      id = prefs.getString(this._idUser);
    } catch (e) {
      debugPrint(e.toString());
    }
    return Future.value(id);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id;
    try {
      id = prefs.getString(this._token);
    } catch (e) {
      debugPrint(e.toString());
    }
    return Future.value(id);
  }

  Future<bool> isConnected() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isConnected = false;
    try {
      String id = prefs.getString(this._idUser);
      if (id != null && id.isNotEmpty) {
        isConnected = true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return Future.value(isConnected);
  }

  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isCleared = false;
    try {
      prefs.clear();
      isCleared = true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return Future.value(isCleared);
  }
}
