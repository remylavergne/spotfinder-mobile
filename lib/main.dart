import 'package:flutter/material.dart';
import 'package:spotfinder/camera.helper.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/screens/create-account.dart';
import 'package:spotfinder/screens/feed.dart';
import 'package:spotfinder/screens/picture-full.screen.dart';
import 'package:spotfinder/screens/pictures-list.screen.dart';
import 'package:spotfinder/screens/retrieve-account.dart';
import 'package:spotfinder/screens/spot-details.screen.dart';
import 'package:spotfinder/views/display-picture-to-create.dart';
import 'package:spotfinder/views/take-picture.dart';

import 'camera.helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CameraHelper.instance.initCameras();

  runApp(SpotFinderApp());
}

class SpotFinderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        routes: <String, WidgetBuilder>{
          CreateAccount.route: (BuildContext context) => CreateAccount(),
          RetrieveAccount.route: (BuildContext context) => RetrieveAccount(),
          TakePictureScreen.route: (BuildContext context) =>
              // ignore: missing_required_param
              TakePictureScreen(),
          DisplayPictureScreen.route: (BuildContext context) =>
              // ignore: missing_required_param
              DisplayPictureScreen(),
          SpotDetailsScreen.route: (BuildContext context) =>
              // ignore: missing_required_param
              SpotDetailsScreen(),
          PicturesDisplayScreen.route: (BuildContext context) =>
              // ignore: missing_required_param
              PicturesDisplayScreen(),
          PictureFullScreen.route: (BuildContext context) =>
              // ignore: missing_required_param
              PictureFullScreen(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
            future: SharedPrefsHelper.instance.isConnected(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                bool isConnected = snapshot.data;

                if (isConnected) {
                  return Feed();
                } else {
                  return CreateAccount();
                }
              } else {
                return Container(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
