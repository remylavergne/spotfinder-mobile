import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotfinder/views/display-picture-to-create.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

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
          children: [
            this._cameraPreview(),
            this._header(),
            this._pictureAction(context),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      margin: EdgeInsets.only(
        top: 32.0,
        left: 16.0,
      ),
      child: Text(
        'SpotFinder',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
        ),
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

  Widget _pictureAction(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () async {
            this._takePicture(context);
          },
          onLongPress: () {
            // TODO: Record clip
          },
          child: Container(
            margin: EdgeInsets.only(
              bottom: 16.0,
            ),
            width: 80.0,
            height: 80.0,
            child: Text(''),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.pink[100]),
          ),
        ),
      ),
    );
  }

  Future<Widget> _takePicture(BuildContext ctx) async {
    debugPrint('Prise de photo');

    try {
      await _initializeControllerFuture;

      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png', // TODO => get user specific id
      );

      await _controller.takePicture(path);

      Navigator.push(
        ctx,
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(imagePath: path),
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
