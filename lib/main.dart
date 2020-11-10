import 'package:flutter/material.dart';
import 'package:spotfinder/camera.helper.dart';
import 'package:spotfinder/screens/onboarding.dart';
import 'package:spotfinder/views/spot-list.widget.dart';
import 'package:spotfinder/views/take-picture.dart';

import 'camera.helper.dart';

void main() async {
  await CameraService.instance.initCameras();
  
  runApp(SpotFinderApp());
}

class SpotFinderApp extends StatelessWidget {
  final TakePictureScreen takePictureScreen =
      TakePictureScreen(camera: CameraService.instance.getCamera());
  final SpotList spotListScreen = SpotList();

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
        home: CreateAccount(), // TODO: Logique
      ),
    );
  }
}
