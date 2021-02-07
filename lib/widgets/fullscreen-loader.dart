import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FullscreenLoader extends StatefulWidget {
  final String message;
  final bool loader;

  const FullscreenLoader({Key key, this.loader = true, this.message = ''})
      : super(key: key);

  @override
  _FullscreenLoaderState createState() => _FullscreenLoaderState();
}

class _FullscreenLoaderState extends State<FullscreenLoader> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: Color(0x66011627),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: this.widget.loader,
              child: CircularProgressIndicator(),
            ),
            Visibility(
              visible: this.widget.message.isNotEmpty,
              child: Container(
                margin: this.widget.loader
                    ? EdgeInsets.only(top: 16.0)
                    : EdgeInsets.only(top: 0.0),
                child: Text(
                  this.widget.message,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
