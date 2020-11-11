import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotfinder/models/user.model.dart';

class SharedPrefsHelper {
  String _username = 'USERNAME';
  String _idUser = 'ID_USER';

  SharedPrefsHelper._privateConstructor();

  static final SharedPrefsHelper instance =
      SharedPrefsHelper._privateConstructor();

  void saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this._idUser, user.id);
    prefs.setString(this._username, user.username);
  }
}
