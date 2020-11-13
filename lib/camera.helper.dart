import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraHelper {
  CameraHelper._privateConstructor();

  List<CameraDescription> _cameras;

  static final CameraHelper instance = CameraHelper._privateConstructor();

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

  Future<bool> canUse() async {
    var status = await Permission.camera.status;
    bool canAccess = false;
    switch (status) {
      case PermissionStatus.granted:
        canAccess = true;
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.undetermined:
      case PermissionStatus.permanentlyDenied:
      default:
        break;
    }

    return Future.value(canAccess);
  }
}
