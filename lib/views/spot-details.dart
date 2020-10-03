import 'package:flutter/material.dart';

class SpotDetails extends StatefulWidget {
  @override
  _SpotDetailsState createState() => _SpotDetailsState();
}

class _SpotDetailsState extends State<SpotDetails> {
  // TODO: Get Spots
  // TODO: Get images
  // TODO: Get comments ?
  List<Widget> spots = List();

  @override
  void initState() {
    this.spots.add(this._spot());
    this.spots.add(this._spot());
    this.spots.add(this._spot());
    this.spots.add(this._spot());
    this.spots.add(this._spot());
    this.spots.add(this._spot());
    this.spots.add(this._spot());
    this.spots.add(this._spot());
    this.spots.add(this._spot());
    this.spots.add(this._spot());
    this.spots.add(this._spot());
    this.spots.add(this._spot());
    this.spots.add(this._spot());
    this.spots.add(this._spot());
    this.spots.add(this._spot());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 50.0,
          left: 12.0,
          right: 12.0,
        ),
        child: Column(
          children: [
            this._imageHeader(),
            Flexible(
              fit: FlexFit.loose,
              child: this._imagesUploadRecently(screenSize),
            ),
            // Debug
            Text('Informations'),
          ],
        ),
      ),
    );
  }

  Widget _imageHeader() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15.0),
        image: DecorationImage(
          image: NetworkImage(
            'https://www.wampark.fr/wp-content/uploads/2020/03/wakeskate8x15.jpg',
          ),
          fit: BoxFit.fill,
        ),
      ),
      height: 200.0,
    );
  }

  Widget _imagesUploadRecently(Size screenSize) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      children: List.generate(this.spots.length, (index) => this.spots[index]),
    );
  }

  Widget _spot() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15.0),
        image: DecorationImage(
          image: NetworkImage(
            'https://www.wampark.fr/wp-content/uploads/2020/03/wakeskate8x15.jpg',
          ),
          fit: BoxFit.fill,
        ),
      ),
      // height: 200.0,
    );
  }
}
