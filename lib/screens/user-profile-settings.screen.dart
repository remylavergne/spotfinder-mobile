import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spotfinder/enums/take-picture-for.enum.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/helpers/camera.helper.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/models/user.model.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/screens/create-account.screen.dart';
import 'package:spotfinder/screens/take-picture.screen.dart';
import 'package:spotfinder/string-methods.dart';

class UserProfileSettingsScreen extends StatelessWidget {
  static final String route = '/user-settings';

  final User user;

  UserProfileSettingsScreen({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
        backgroundColor: Color(0xFF011627),
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: () {
                this._openTakePictureScreen(context);
              },
              child: Text(
                S.of(context).addProfilePicture,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                // TODO
                this._changeCurrentPassword(context, this.user);
              },
              child: Text(
                S.of(context).changePassword,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FlatButton(
                onPressed: () {
                  SharedPrefsHelper.instance.logout().then((value) =>
                      Navigator.pushNamedAndRemoveUntil(context,
                          CreateAccountScreen.route, (route) => false));
                },
                child: Text(
                  capitalize(S.of(context).logout),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  /// Navigation
  ///
  ///

  void _openTakePictureScreen(BuildContext context) {
    CameraHelper.instance.canUse().then((bool canUse) {
      if (canUse) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => TakePictureScreen(
              camera: CameraHelper.instance.getCamera(),
              takePictureFor: TakePictureFor.USER_PROFILE,
              position: Position(),
            ),
          ),
        );
      } else {
        this.showDialogOpenSettings(
          context,
          Text(S.current.permissionDialogTitle),
          Text(S.current.cameraPermissionMandatory),
        );
      }
    });
  }

  void showDialogOpenSettings(
      BuildContext context, Widget title, Widget message) {
    showDialog(
        builder: (_) => AlertDialog(
              title: title,
              content: message,
              actions: [
                FlatButton(
                  onPressed: () async {
                    await Geolocator.openAppSettings();
                  },
                  child: Text(S.current.openSettings),
                ),
                FlatButton(
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  child: Text(S.current.okay),
                ),
              ],
            ),
        barrierDismissible: false,
        context: context);
  }

// TODO => Finir la modal
  void _changeCurrentPassword(BuildContext context, User user) {
    // Open Popup
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Container(
          color: Colors.red,
          child: Form(
            child: Column(
              children: [
                Text('Current password'),
                TextFormField(),
                Text('New password'),
                TextFormField(),
                TextFormField(),
                FlatButton(
                  onPressed: () {
                    debugPrint('Call Repository');
                  },
                  child: Text('Change'),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
