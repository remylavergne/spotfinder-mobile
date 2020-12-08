import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/helpers/camera.helper.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/screens/create-account.screen.dart';
import 'package:spotfinder/screens/display-clear-password.screen.dart';
import 'package:spotfinder/screens/display-picture-to-create.screen.dart';
import 'package:spotfinder/screens/feed.screen.dart';
import 'package:spotfinder/screens/picture-full.screen.dart';
import 'package:spotfinder/screens/pictures-list.screen.dart';
import 'package:spotfinder/screens/retrieve-account.screen.dart';
import 'package:spotfinder/screens/spot-details.screen.dart';
import 'package:spotfinder/screens/take-picture.screen.dart';
import 'package:spotfinder/screens/user-profile.screen.dart';

import 'helpers/camera.helper.dart';

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
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        routes: <String, WidgetBuilder>{
          CreateAccountScreen.route: (BuildContext context) =>
              CreateAccountScreen(),
          RetrieveAccountScreen.route: (BuildContext context) =>
              RetrieveAccountScreen(),
          ClearPasswordScreen.route: (BuildContext context) =>
              // ignore: missing_required_param
              ClearPasswordScreen(),
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
          UserProfileScreen.route: (BuildContext context) =>
              // ignore: missing_required_param
              UserProfileScreen(),
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
                  return FeedScreen();
                } else {
                  return CreateAccountScreen();
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
