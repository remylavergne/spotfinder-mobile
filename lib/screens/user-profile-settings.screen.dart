import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spotfinder/enums/take-picture-for.enum.dart';
import 'package:spotfinder/helpers/camera.helper.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/screens/take-picture.screen.dart';

class UserProfileSettingsScreen extends StatelessWidget {
  static final String route = '/user-settings';
  final String userId;
  UserProfileSettingsScreen({Key key, @required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'), // TODO: Translate
        backgroundColor: Color(0xFF011627),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // TODO: Translate
            FlatButton(
                onPressed: () {
                  this._openTakePictureScreen(context);
                },
                child: Text('Add profile picture')),
            FlatButton(
              onPressed: () {
                // TODO
                SharedPrefsHelper.instance.logout();
              },
              child: Text(
                'Disconnect',
                style: TextStyle(
                  color: Colors.red,
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
    Navigator.push(
      context,
      MaterialPageRoute(
        // TODO: Check permissions
        builder: (BuildContext context) => TakePictureScreen(
          camera: CameraHelper.instance.getCamera(),
          takePictureFor: TakePictureFor.USER_PROFILE,
          position: Position(),
        ),
      ),
    );
  }
}
