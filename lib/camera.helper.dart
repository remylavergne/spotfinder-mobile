import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

class CameraService {
  CameraService._privateConstructor();

  List<CameraDescription> _cameras;

  static final CameraService instance = CameraService._privateConstructor();

  void _getFirstCameraAvailable() async {
    WidgetsFlutterBinding.ensureInitialized();
    this._cameras = await availableCameras();
  }

  Future<CameraDescription> getCamera([int number = 0]) async {
    if (this._cameras.isEmpty) {
      this._getFirstCameraAvailable();
    }
    return Future.value(this._cameras[number]);
  }
}
