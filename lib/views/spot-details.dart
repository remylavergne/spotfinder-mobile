import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotfinder/models/spot.model.dart';
import 'package:spotfinder/repositories/repository.dart';

class SpotDetails extends StatefulWidget {
  @override
  _SpotDetailsState createState() => _SpotDetailsState();
}

class _SpotDetailsState extends State<SpotDetails> {
  // TODO: Get Spots
  // TODO: Get images
  // TODO: Get comments ?
  Future<List<Spot>> spots;

  @override
  void initState() {
    this.spots = Repository().getSpots();
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
            this._imagesUploadRecently(screenSize),
            this._globalInformations(),
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
    return Container(
      padding: EdgeInsets.only(
        top: 16.0,
      ),
      // color: Colors.red,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          this._spot((screenSize.width / 3) - 24),
          this._spot((screenSize.width / 3) - 24),
          this._spot((screenSize.width / 3) - 24),
        ],
      ),
    );
  }

  Widget _spot([double size = 200.0]) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15.0),
        image: DecorationImage(
          image: NetworkImage(
            'https://www.wampark.fr/wp-content/uploads/2020/03/wakeskate8x15.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      height: size,
      width: size,
    );
  }

  Widget _globalInformations() {
    return Container(
      padding: EdgeInsets.only(
        top: 12.0,
      ),
      width: double.infinity,
      // color: Colors.green[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title
          Text(
            'Global Informations',
            style: GoogleFonts.lato(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          this._informationsBuilder('Name', 'spot::name'),
          this._informationsBuilder('Location', 'spot::location'),
          this._informationsBuilder('Address', 'spot::address'),
          this._informationsBuilder('Website', 'spot::website'),
        ],
      ),
    );
  }

  Widget _informationsBuilder(String key, String value) {
    return Container(
      padding: EdgeInsets.only(top: 4.0),
      child: Text('$key: $value'),
    );
  }
}
