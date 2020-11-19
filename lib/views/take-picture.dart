import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotfinder/enums/take-picture-for.enum.dart';
import 'package:spotfinder/views/display-picture-to-create.dart';

class TakePictureScreen extends StatefulWidget {
  static String route = '/take-picture';
  final CameraDescription camera;
  final Position position;
  final TakePictureFor takePictureFor;
  final String spotID;

  const TakePictureScreen(
      {Key key,
      @required this.camera,
      @required this.position,
      @required this.takePictureFor,
      this.spotID})
      : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                'Retour',
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
                'Capturer',
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
          return Center(child: CircularProgressIndicator());
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
            spotID: widget.spotID,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
