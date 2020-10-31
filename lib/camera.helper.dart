import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

class CameraService {
  CameraService._privateConstructor();

  List<CameraDescription> _cameras;

  static final CameraService instance = CameraService._privateConstructor();

  Future<void> initCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    this._cameras = await availableCameras();
  }

  CameraDescription getCamera([int number = 0]) {
    if (this._cameras.isEmpty) {
      return null;
    }
    return this._cameras[number];
  }
}
