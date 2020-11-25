import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/models/picture.model.dart';

class PictureFullScreen extends StatelessWidget {
  static String route = '/picture-fullscreen';
  final Picture picture;
  PictureFullScreen({Key key, @required this.picture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo'),
        backgroundColor: Color(0xFF011627),
      ),
      body: Container(
        color: Colors.red,
        child: Image.network(
          '${Constants.getBaseApi()}/picture/id/${picture.id}',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
