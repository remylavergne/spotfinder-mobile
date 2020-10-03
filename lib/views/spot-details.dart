import 'package:flutter/material.dart';

class SpotDetails extends StatefulWidget {
  @override
  _SpotDetailsState createState() => _SpotDetailsState();
}

class _SpotDetailsState extends State<SpotDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: RaisedButton(
              child: Text('Go back'), onPressed: () => Navigator.pop(context)),
        ),
      ),
    );
  }
}
