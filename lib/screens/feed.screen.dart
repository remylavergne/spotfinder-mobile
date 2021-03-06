import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/helpers/camera.helper.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/enums/take-picture-for.enum.dart';
import 'package:spotfinder/helpers/geolocation.helper.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/helpers/throttling.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/models/spot.model.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/screens/spot-details.screen.dart';
import 'package:spotfinder/screens/user-profile.screen.dart';
import 'package:spotfinder/widgets/application-title.dart';
import 'package:spotfinder/widgets/search-field.dart';
import 'package:spotfinder/screens/take-picture.screen.dart';
import 'package:spotfinder/widgets/square-photo-item.dart';

class FeedScreen extends StatefulWidget {
  static String route = '/feed';

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<FeedScreen> with SingleTickerProviderStateMixin {
  TabController tabController;
  Throttling createSpotThrottling = Throttling(Duration(seconds: 2));
  Future<ResultWrapper<List<Spot>>> _newest;
  Future<ResultWrapper<List<Spot>>> _nearest;

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
      appBar: this._getAppBar(),
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background view
            Container(
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: this.tabController,
                      children: [
                        this._displayNewestSpots(mediaQueryData),
                        FutureBuilder<Position>(
                            future:
                                GeolocationHelper.instance.getCurrentPosition(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                Position position = snapshot.data;

                                this._nearest = Repository()
                                    .getNearestPaginatedSpots(position, 1, 20);

                                return this._displayNearestSpots(
                                    mediaQueryData, position);
                              }
                              if (snapshot.hasError) {
                                return this._retry(
                                    () => GeolocationHelper.instance
                                            .getCurrentPosition()
                                            .then((Position position) {
                                          if (position != null) {
                                            this._refreshNearestSpots(position);
                                          }
                                        }).catchError((e) => debugPrint(e)),
                                    S.current.errorGetSpots);
                              } else {
                                return Container(
                                  child: Center(
                                    child: Container(
                                      width: 50.0,
                                      height: 50.0,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Button to create
            this._createButton(mediaQueryData),
          ],
        ),
      ),
    );
  }

  AppBar _getAppBar() {
    return AppBar(
      title: ApplicationTitle(
        title: S.current.spotfinder,
        size: 56.0,
        strokeSize: 2.0,
        backgroundColor: Color(0xFF011627),
      ),
      backgroundColor: Color(0xFF011627),
      bottom: TabBar(
        indicatorColor: Color(0xFFD4D4D4),
        // labelPadding: EdgeInsets.only(bottom: 10.0),
        tabs: [
          Tab(icon: Text(S.current.newestTabTitle)),
          Tab(icon: Text(S.current.closestTabTitle)),
        ],
        controller: this.tabController,
      ),
      actions: [
        // IconButton(icon: Icon(Icons.chat), onPressed: () {}),
        // IconButton(icon: Icon(Icons.mail), onPressed: () {}),
        IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () async {
              String currentUserId = await SharedPrefsHelper.instance.getId();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => UserProfileScreen(
                    userId: currentUserId,
                    isCurrentUser: true,
                  ),
                ),
              );
            }),
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: Search());
            }),
      ],
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
                  child: Text(S.current.openSettings),
                ),
                FlatButton(
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  child: Text(S.current.okay),
                ),
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
        takePictureFor: TakePictureFor.CREATION,
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
    CameraHelper.instance.canUse().then((bool canUse) {
      if (canUse) {
        return GeolocationHelper.instance.isLocationServiceEnabled();
      } else {
        this.showDialogOpenSettings(
          context,
          Text(S.current.permissionDialogTitle),
          Text(S.current.cameraPermissionMandatory),
        );
      }
    }).then((bool isLocationServiceEnable) {
      if (isLocationServiceEnable) {
        return GeolocationHelper.instance.hasPermission();
      } else {
        this.showDialogOpenSettings(
          context,
          Text(S.current.permissionDialogTitle),
          Text(S.current.locationServiceOff),
        );
      }
    }).then((bool hasAccessToGeolocation) {
      if (hasAccessToGeolocation) {
        this.getCurrentPositionAndNavigate(context);
      } else {
        this.showDialogOpenSettings(
          context,
          Text(S.current.permissionDialogTitle),
          Text(S.current.gpsPermissionMandatory),
        );
      }
    });
  }

  Widget _displayNewestSpots(MediaQueryData mediaQuery) {
    return FutureBuilder<ResultWrapper<List<Spot>>>(
        future: this._newest,
        builder: (BuildContext context,
            AsyncSnapshot<ResultWrapper<List<Spot>>> snapshot) {
          if (snapshot.hasData) {
            ResultWrapper<List<Spot>> wrapper = snapshot.data;
            List<Spot> spots = wrapper.result;

            if (spots.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  this._refreshNewestSpots();
                },
                child: Container(
                  child: Center(
                    child: Text('No data'),
                  ),
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  this._refreshNewestSpots();
                },
                child: GridView.builder(
                  itemCount: spots.length,
                  padding: EdgeInsets.only(top: 0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SpotDetailsScreen(spot: spots[index])));
                    },
                    child: this._getSpotWidget(spots[index]),
                  ),
                ),
              );
            }
          } else if (snapshot.hasError) {
            return this._retry(
                () => this._refreshNewestSpots(), S.current.errorGetSpots);
          } else {
            return Container(
              child: Center(
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        });
  }

  Container _retry(Function() refresh, String textDisplayed) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              textDisplayed,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          IconButton(
              icon: Icon(Icons.restore),
              onPressed: () {
                refresh();
              })
        ],
      ),
    );
  }

  void _refreshNewestSpots() {
    setState(() {
      this._newest = Repository().getPaginatedSpots(1, 20);
    });
  }

  void _refreshNearestSpots(Position position) {
    setState(() {
      this._nearest = Repository().getNearestPaginatedSpots(position, 1, 20);
    });
  }

  FutureBuilder<ResultWrapper<List<Spot>>> _displayNearestSpots(
      MediaQueryData mediaQuery, Position position) {
    return FutureBuilder<ResultWrapper<List<Spot>>>(
        future: this._nearest,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            ResultWrapper<List<Spot>> wrapper = snapshot.data;
            List<Spot> spots = wrapper.result;

            if (spots.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  this._refreshNearestSpots(position);
                },
                child: Container(
                  child: Center(
                    child: Text('No data'),
                  ),
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  this._refreshNearestSpots(position);
                },
                child: GridView.builder(
                  itemCount: spots.length,
                  padding: EdgeInsets.only(top: 0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SpotDetailsScreen(spot: spots[index])));
                    },
                    child: this._getSpotWidget(spots[index]),
                  ),
                ),
              );
            }
          } else if (snapshot.hasError) {
            return this._retry(() => this._refreshNearestSpots(position),
                S.current.errorPermissionNearestSpots);
          } else {
            return Container(
              child: Center(
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        });
  }

  GridTile _getSpotWidget(Spot spot) {
    return GridTile(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent, width: 4.0),
        ),
        child: SquarePhotoItem(
          url: '${Constants.getBaseApi()}/picture/id/${spot.getThumbnail()}',
          size: 120.0,
        ),
      ),
    );
  }

  Container _createButton(MediaQueryData mediaQueryData) {
    return Container(
      alignment: Alignment.bottomCenter,
      width: 180.0,
      margin: EdgeInsets.only(bottom: mediaQueryData.padding.bottom + 16.0),
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
          S.current.create,
          style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
