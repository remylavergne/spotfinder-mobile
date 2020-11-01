import 'package:flutter/material.dart';
import 'package:spotfinder/camera.helper.dart';
import 'package:spotfinder/views/spot-list.widget.dart';
import 'package:spotfinder/views/take-picture.dart';

import 'camera.helper.dart';

void main() async {
  await CameraService.instance.initCameras();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final controller = PageController(
    initialPage: 1,
  );

  final TakePictureScreen takePictureScreen =
      TakePictureScreen(camera: CameraService.instance.getCamera());
  final SpotList spotListScreen = SpotList();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PageView(
        controller: this.controller,
        children: [
          this.takePictureScreen,
          this.spotListScreen,
        ],
      ),
    );
  }
}