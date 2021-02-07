import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FullscreenLoader extends StatefulWidget {
  final String message;

  const FullscreenLoader({Key key, this.message}) : super(key: key);

  @override
  _FullscreenLoaderState createState() => _FullscreenLoaderState();
}

class _FullscreenLoaderState extends State<FullscreenLoader> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: Color(0x66011627),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
