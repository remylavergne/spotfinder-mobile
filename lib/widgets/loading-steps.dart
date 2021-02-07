import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoadingStep extends StatelessWidget {
  final String text;

  const LoadingStep({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(this.text),
          )
        ],
      ),
    );
  }
}
