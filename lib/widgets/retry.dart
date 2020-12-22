import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/generated/l10n.dart';

class Retry extends StatelessWidget {
  final VoidCallback retryCalled;

  Retry({Key key, @required this.retryCalled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              S.of(context).errorAndRetry,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          IconButton(
            icon: Icon(Icons.restore),
            onPressed: () {
              this.retryCalled();
            },
          ),
        ],
      ),
    );
  }
}
