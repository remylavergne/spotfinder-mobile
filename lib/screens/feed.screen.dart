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
import 'package:spotfinder/models/dto/search-with-pagination.dto.dart';
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

class _FeedState extends State<FeedScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController tabController;
  Throttling createSpotThrottling = Throttling(Duration(seconds: 2));
  Future<List<ResultWrapper<List<Spot>>>> _newest;
  Future<ResultWrapper<List<Spot>>> _nearest;
  Position _position;

  @override
  void initState() {
    super.initState();
    this.tabController = TabController(length: 2, vsync: this);
    this._newest = SharedPrefsHelper.instance.getId().then((String id) =>
        Repository().getNewestSpotsWithUserPendingSpots(
            new SearchWithPagination(id, 1, 200), 1, 200));
    this._nearest = GeolocationHelper.instance
        .getCurrentPosition()
        .then((Position position) {
      this._position = position;
      return Repository().getNearestPaginatedSpots(position, 1, 200);
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      appBar: this._getAppBar(),
      body: Column(
        children: [
          this._getBody(context),
          this._createButton(mediaQueryData),
        ],
      ),
    );
  }

  AppBar _getAppBar() {
    return AppBar(
      title: ApplicationTitle(
        title: S.current.appTitle,
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
                  builder: (BuildContext context) =>
                      UserProfileScreen(userId: currentUserId),
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

  Widget _getBody(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Expanded(
      child: TabBarView(
        controller: this.tabController,
        children: [
          FutureBuilder(
              future: this._newest,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return this._displayNewestSpots(mediaQueryData);
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
          FutureBuilder(
              future: this._nearest,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  ResultWrapper<List<Spot>> wrapper = snapshot.data;
                  List<Spot> spots = wrapper.result;

                  if (spots.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        this._refreshNearestSpots(this._position);
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
                        this._refreshNearestSpots(this._position);
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
                      () => this._refreshNearestSpots(this._position),
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
              }),
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
    return FutureBuilder<List<ResultWrapper<List<Spot>>>>(
        future: this._newest,
        builder: (BuildContext context,
            AsyncSnapshot<List<ResultWrapper<List<Spot>>>> snapshot) {
          if (snapshot.hasData) {
            // Extract all spots - Pending spots on top of the list
            List<Spot> pendingSpots = snapshot.data[0].result;
            List<Spot> newestSpots = snapshot.data[1].result;
            // Concat all
            List<Spot> spots = pendingSpots + newestSpots;

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
                          builder: (BuildContext context) => SpotDetailsScreen(
                            spot: spots[index],
                          ),
                        ),
                      );
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
      this._newest = SharedPrefsHelper.instance.getId().then((String id) =>
          Repository().getNewestSpotsWithUserPendingSpots(
              new SearchWithPagination(id, 1, 200), 1, 200));
    });
  }

  void _refreshNearestSpots(Position position) {
    setState(() {
      this._nearest = Repository().getNearestPaginatedSpots(position, 1, 200);
    });
  }

  GridTile _getSpotWidget(Spot spot) {
    return GridTile(
      footer: spot.isPending()
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Center(
                child: Icon(
                  Icons.public_off,
                  color: Color(0xCCFF7761),
                ),
              ),
            )
          : null,
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
      color: Color(0xFF011627),
      child: SizedBox(
        width: double.maxFinite,
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          color: Color(0xFF011627),
          textColor: Colors.white,
          height: 56.0 + mediaQueryData.padding.bottom,
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
      ),
    );
  }
}
