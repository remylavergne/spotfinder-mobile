import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spotfinder/camera.helper.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/enums/take-picture-for.enum.dart';
import 'package:spotfinder/helpers/geolocation.helper.dart';
import 'package:spotfinder/helpers/throttling.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/models/spot.model.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/screens/spot-details.screen.dart';
import 'package:spotfinder/views/take-picture.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> with SingleTickerProviderStateMixin {
  TabController tabController;
  Throttling createSpotThrottling = Throttling(Duration(seconds: 2));
  GlobalKey _keyHeader = GlobalKey();
  Future<ResultWrapper<List<Spot>>> _newest;
  Future<ResultWrapper<List<Spot>>> _closest;

  @override
  void initState() {
    this.tabController = TabController(length: 2, vsync: this);
    this._newest = Repository().getPaginatedSpots(1, 20);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background view
            Container(
              child: Column(
                children: [
                  this._header(mediaQueryData, this.tabController),
                  Expanded(
                    child: TabBarView(
                      controller: this.tabController,
                      children: [
                        this._gridCloseSpotMOCK(),
                        this._displayNewestSpots(mediaQueryData),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Button to create
            Container(
              alignment: Alignment.bottomCenter,
              width: 180.0,
              margin:
                  EdgeInsets.only(bottom: mediaQueryData.padding.bottom + 16.0),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                color: Color(0xFF148F12),
                textColor: Colors.white,
                height: 56.0,
                onPressed: () async {
                  this.createSpotThrottling.throttle(() {
                    this._startCreation(context);
                  });
                },
                child: Text(
                  'Créer',
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(MediaQueryData mediaQueryData, TabController tabController) {
    return Container(
      key: this._keyHeader,
      color: Color(0xFF011627),
      // height: 150.0,
      padding: EdgeInsets.only(top: mediaQueryData.padding.top),
      child: Column(
        children: [
          // Champs de recherche
          Container(
            margin: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
            ),
            child: Container(
              height: 35.0,
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    contentPadding: const EdgeInsets.all(8.0),
                    // isDense: true,
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(6.0),
                      ),
                    ),
                    filled: true,
                    fillColor: Color(0xFFD4D4D4),
                    hintText: 'Search'),
              ),
            ),
          ),
          // TabBar
          Container(
            margin: EdgeInsets.only(top: 16.0),
            // padding: EdgeInsets.only(bottom: 10.0),
            child: TabBar(
              indicatorColor: Color(0xFFD4D4D4),
              labelPadding: EdgeInsets.only(bottom: 10.0),
              tabs: [Text('Proches'), Text('Récents')],
              controller: this.tabController,
            ),
          )
        ],
      ),
    );
  }

  void showDialogOpenSettings(
      BuildContext context, Widget title, Widget message) {
    showDialog(
        builder: (_) => AlertDialog(
              title: title,
              content: message,
              actions: [
                FlatButton(
                    onPressed: () async {
                      await Geolocator.openAppSettings();
                    },
                    child: Text('Open settings')),
                FlatButton(
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                    child: Text('Ok')),
              ],
            ),
        barrierDismissible: false,
        context: context);
  }

  Route _animateCreationSpotScreen(Position position) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          TakePictureScreen(
        position: position,
        camera: CameraHelper.instance.getCamera(),
        takePictureFor: TakePictureFor.creation,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void getCurrentPositionAndNavigate(BuildContext context) {
    GeolocationHelper.instance.getCurrentPosition().then((Position position) =>
        Navigator.push(context, this._animateCreationSpotScreen(position)));
  }

  void _startCreation(BuildContext context) {
    this.getCurrentPositionAndNavigate(context);

    // todo: rework check flow
    // CameraHelper.instance.canUse().then((bool canUse) {
    //   if (canUse) {
    //     return GeolocationHelper.instance.isLocationServiceEnabled();
    //   } else {
    //     this.showDialogOpenSettings(context, Text('Problem...'),
    //         Text('Vous devez donner accès à l\'appareil photo'));
    //   }
    // }).then((bool isLocationServiceEnable) {
    //   if (isLocationServiceEnable) {
    //     return GeolocationHelper.instance.hasPermission();
    //   } else {
    //     this.showDialogOpenSettings(
    //         context, Text('Problem...'), Text('Le GPS n\'est pas allumé'));
    //   }
    // }).then((bool hasAccessToGeolocation) {
    //   if (hasAccessToGeolocation) {
    //     this.getCurrentPositionAndNavigate(context);
    //   } else {
    //     this.showDialogOpenSettings(context, Text('Problem...'),
    //         Text('Vous devez donner accès à la géolocalisation'));
    //   }
    // });
  }

  Widget _displayNewestSpots(MediaQueryData mediaQuery) {
    return FutureBuilder<ResultWrapper<List<Spot>>>(
        future: this._newest,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            ResultWrapper<List<Spot>> wrapper = snapshot.data;
            List<Spot> spots = wrapper.result;

            return GridView.builder(
              itemCount: spots.length,
              padding: EdgeInsets.only(top: 0),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, SpotDetailsScreen.route,
                  //     arguments: spots[index]);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              SpotDetailsScreen(spot: spots[index])));
                },
                child: this._getSpotWidget(spots[index]),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur pendant la récupération des Spots...'));
          } else {
            return this._loadingScreen(mediaQuery);
          }
        });
  }

  Widget _loadingScreen(MediaQueryData mediaQuery) {
    double marginTop =
        ((mediaQuery.size.height - (80.0 + mediaQuery.padding.top)) / 2) - 25.0;
    double marginLeft = (mediaQuery.size.width / 2) - 25.0;
    // todo: Use KeyHeader here, for header height -> replace 56.0

    return Container(
      color: Color(0xAB011627),
      child: AspectRatio(
        aspectRatio: mediaQuery.size.aspectRatio,
        child: Container(
          margin: EdgeInsets.only(
              top: marginTop,
              left: marginLeft,
              bottom: marginTop,
              right: marginLeft),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _gridCloseSpotMOCK() {
    return GridView.count(
      padding: EdgeInsets.only(top: 0),
      crossAxisCount: 3,
      children: [
        GridTile(
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5)),
                child: Image.network(
                    'https://www.skatereview.com/wp-content/uploads/2017/07/skateboard-trick-tipp-nollie-heelflip.jpg',
                    fit: BoxFit.cover))),
        GridTile(
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5)),
                child: Image.network(
                    'https://i.pinimg.com/originals/f2/26/15/f22615c8787e5e99406c22c791d62d32.jpg',
                    fit: BoxFit.cover))),
        GridTile(
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5)),
                child: Image.network(
                    'https://www.activethrills.com/wp-content/uploads/2017/09/skateboard-tricks-780x400.jpg',
                    fit: BoxFit.cover))),
        GridTile(
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5)),
                child: Image.network(
                    'https://i.ytimg.com/vi/gSEvU9drzfw/maxresdefault.jpg',
                    fit: BoxFit.cover))),
        GridTile(
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5)),
                child: Image.network(
                    'https://i.ytimg.com/vi/9hySkXBQJTM/hqdefault.jpg',
                    fit: BoxFit.cover))),
        GridTile(
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5)),
                child: Image.network(
                    'https://i.pinimg.com/originals/c5/2b/5b/c52b5b980bbfe3e79993823bb93149f7.jpg',
                    fit: BoxFit.cover))),
      ],
    );
  }

  Widget _getSpotWidget(Spot spot) {
    return GridTile(
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5)),
            child: Image.network(
                '${Constants.getBaseApi()}/picture/id/${spot.pictureId}',
                fit: BoxFit.cover)));
  }
}
