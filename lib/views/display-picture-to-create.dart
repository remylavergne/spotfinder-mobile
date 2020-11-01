import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, @required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.blue,
          child: Image.file(
            File(imagePath),
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: RaisedButton(
              child: Text('Create Spot'),
              onPressed: () {
                debugPrint('Create Spot');
              }),
        ),
        Positioned(
          bottom: 20.0,
          left: 20.0,
          child: RaisedButton(
              child: Text('Cancel'),
              onPressed: () {
                debugPrint('Cancel create');
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }
}
