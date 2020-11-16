import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/models/spot.model.dart';

class SpotDetailsScreen extends StatefulWidget {
  static String route = '/spot-details';

  SpotDetailsScreen({Key key}) : super(key: key);

  @override
  _SpotDetailsScreenState createState() => _SpotDetailsScreenState();
}

class _SpotDetailsScreenState extends State<SpotDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final Spot spot = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Spot 🛹'),
        backgroundColor: Color(0xFF011627),
      ),
      body: Container(
        child: Center(child: Text('ID du Spot ${spot.id}')),
      ),
    );
  }
}
