import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/widgets/loading-steps.dart';

class FullscreenLoader extends StatefulWidget {
  final String message;
  final bool loader;
  final List<LoadingStep> steps;

  const FullscreenLoader(
      {Key key, this.loader = true, this.message = '', this.steps})
      : super(key: key);

  @override
  _FullscreenLoaderState createState() => _FullscreenLoaderState();
}

class _FullscreenLoaderState extends State<FullscreenLoader> {
  @override
  void initState() {
    super.initState();
    if (this.widget.steps != null && this.widget.message.isNotEmpty) {
      throw Error();
    }
  }

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
            // Loader
            Visibility(
              visible: this.widget.loader,
              child: CircularProgressIndicator(),
            ),
            // Simple message
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
            ),
            // Steps list
            Visibility(
              visible:
                  this.widget.steps != null && this.widget.steps.isNotEmpty,
              child: ListView(
                shrinkWrap: true,
                children: this.widget.steps,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
