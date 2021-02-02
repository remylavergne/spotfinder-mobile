import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spotfinder/enums/camera-type.enum.dart';
import 'package:spotfinder/enums/take-picture-for.enum.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/helpers/camera.helper.dart';
import 'package:spotfinder/screens/display-picture-to-create.screen.dart';
import 'package:spotfinder/widgets/bottom-action-button.dart';

class TakePictureScreen extends StatefulWidget {
  static String route = '/take-picture';
  final CameraLocation cameraLocation;
  final Position position;
  final TakePictureFor takePictureFor;
  final String id;

  const TakePictureScreen({
    Key key,
    @required this.position,
    @required this.takePictureFor,
    this.id,
    this.cameraLocation = CameraLocation.BACK,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen>
    with WidgetsBindingObserver {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  int _cameraSwipes = 0;
  CameraDescription _activeCamera;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    switch (widget.cameraLocation) {
      case CameraLocation.FRONT:
        this._cameraSwipes = 1;
        break;
      case CameraLocation.BACK:
      default:
        this._cameraSwipes = 0;
        break;
    }
    this._activeCamera = CameraHelper.instance.getCamera(this._cameraSwipes);

    _controller = CameraController(this._activeCamera, ResolutionPreset.high,
        enableAudio: false);

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_controller == null || !_controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_controller != null) {
        onNewCameraSelected(_controller.description);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Workaround for camera permission status
    CameraHelper.instance.canUse().then((bool canUse) {
      if (!canUse) {
        Navigator.pop(context);
      }
    });

    return Scaffold(
      appBar: this._getAppBar(context),
      body: Container(
        color: Color(0xFF011627),
        child: Stack(
          children: [
            Center(
              child: Text(
                widget.takePictureFor == TakePictureFor.USER_PROFILE &&
                        this._cameraSwipes % 2 == 0
                    ? '🤡'
                    : '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                ),
              ),
            ),
            Stack(
              children: [
                GestureDetector(
                  onDoubleTap: () {
                    if (this._cameraSwipes % 2 == 0) {
                      this._activeCamera = CameraHelper.instance.getCamera(1);
                    } else {
                      this._activeCamera = CameraHelper.instance.getCamera(0);
                    }

                    this._cameraSwipes++;
                    this.onNewCameraSelected(this._activeCamera);
                  },
                  child: this._cameraPreview(),
                ),
                BottomActionButton(
                  parentContext: context,
                  text: S.of(context).takePictureAction,
                  onTap: () => this.onTakePictureButtonPressed(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar _getAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF011627),
      title: Text(S.of(context).takePhoto),
    );
  }

  /// Display camera on entire screen
  Widget _cameraPreview() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(_controller);
        } else {
          return Container(child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  void onTakePictureButtonPressed(BuildContext context) {
    takePicture().then((XFile file) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: file.path,
            position: widget.position,
            takePictureFor: widget.takePictureFor,
            id: widget.id,
          ),
        ),
      );
    });
  }

  Future<XFile> takePicture() async {
    if (!_controller.value.isInitialized) {
      // showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (_controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await _controller.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // If the controller is updated then update the UI.
    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
        debugPrint('Camera error ${_controller.value.errorDescription}');
      }
    });

    try {
      await _controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _showCameraException(CameraException e) {
    debugPrint('Error: ${e.code}\n${e.description}');
  }
}
