import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotfinder/enums/take-picture-for.enum.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/helpers/camera.helper.dart';
import 'package:spotfinder/screens/display-picture-to-create.screen.dart';

class TakePictureScreen extends StatefulWidget {
  static String route = '/take-picture';
  final CameraDescription camera;
  final Position position;
  final TakePictureFor takePictureFor;
  final String id;

  const TakePictureScreen(
      {Key key,
      @required this.camera,
      @required this.position,
      @required this.takePictureFor,
      this.id})
      : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen>
    with WidgetsBindingObserver {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = CameraController(widget.camera, ResolutionPreset.high,
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
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            this._cameraPreview(),
            this._actionsButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _actionsButtons(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 16.0, right: 16.0),
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: mediaQueryData.padding.bottom + 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 180.0,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              color: Color(0xFF011627),
              textColor: Colors.white,
              height: 56.0,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                S.current.back,
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            width: 180.0,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              color: Color(0xFF276FBF),
              textColor: Colors.white,
              height: 56.0,
              onPressed: () {
                this._takePicture(context);
              },
              child: Text(
                S.current.takePictureAction,
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
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

  Future<void> _takePicture(BuildContext ctx) async {
    try {
      await _initializeControllerFuture;

      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      await _controller.takePicture(path);

      Navigator.push(
        ctx,
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: path,
            position: widget.position,
            takePictureFor: widget.takePictureFor,
            id: widget.id,
          ),
        ),
      );
    } catch (e) {
      print(e);
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
