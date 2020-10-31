import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:spotfinder/camera.helper.dart';
import 'package:spotfinder/colors.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/views/spot-details.dart';
import 'package:spotfinder/views/take-picture.dart';

import 'camera.helper.dart';
import 'models/spot.model.dart';

void main() async {
  await CameraService.instance.initCameras();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TakePictureScreen(
        camera: CameraService.instance.getCamera(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PagingController<int, Spot> _pagingController =
      PagingController(firstPageKey: 0);

  Future<List<Spot>> spots;

  @override
  void initState() {
    this.spots = Repository().getSpots();
    final response = Repository().getPaginatedSpots(0, 20);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: Colors.green,
        padding: EdgeInsets.only(top: 56.0, left: 16.0, right: 16.0),
        child: Column(
          children: [
            this._header(),
            this._spotList(),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _header() {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(
        bottom: 20.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'SpotFinder',
            style: GoogleFonts.architectsDaughter(
              fontSize: 42.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          _searchButton()
        ],
      ),
    );
  }

  Widget _searchButton() {
    return GestureDetector(
      onTap: () {
        print('Search clicked');
      },
      child: Container(
        height: 40.0,
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            shape: BoxShape.rectangle,
            color: palette['Aquamarine']),
        child: Center(
          child: Text("search"),
        ),
      ),
    );
  }

  Widget _spotList() {
    return FutureBuilder(
        future: this.spots,
        builder: (BuildContext context, AsyncSnapshot<List<Spot>> snapshot) {
          if (snapshot.hasData) {
            final spots = snapshot.data;

            return Expanded(
              child: Container(
                // color: Colors.green,
                child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                          height: 12.0,
                          color: Colors.transparent,
                        ),
                    itemCount: spots.length,
                    itemBuilder: (BuildContext context, int index) {
                      return this._generateSpotItem(spots[index]);
                    }),
              ),
            );
          } else {
            return Expanded(
              child: Container(
                color: Colors.green,
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  Widget _generateSpotItem(Spot spot) {
    return GestureDetector(
      child: Card(
        child: Stack(
          children: [
            Container(
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
            ),
            // Expanded(
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.maxFinite,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: palette['HeliotropeGrayTransparent'],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Hipnotic cable park',
                      style: GoogleFonts.lato(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      onTap: () {
        debugPrint('Spot clicked');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SpotDetails()),
        );
      },
    );
  }
}
