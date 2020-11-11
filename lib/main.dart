import 'package:flutter/material.dart';
import 'package:spotfinder/camera.helper.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/screens/create-account.dart';
import 'package:spotfinder/screens/feed.dart';

import 'camera.helper.dart';

void main() async {
  await CameraService.instance.initCameras();

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
