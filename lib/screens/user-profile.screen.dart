import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/enums/camera-type.enum.dart';
import 'package:spotfinder/enums/take-picture-for.enum.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/helpers/camera.helper.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/models/dto/search-with-pagination.dto.dart';
import 'package:spotfinder/models/picture.model.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/models/spot.model.dart';
import 'package:spotfinder/models/user-statistics.model.dart';
import 'package:spotfinder/models/user.model.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/screens/picture-full.screen.dart';
import 'package:spotfinder/screens/pictures-list.screen.dart';
import 'package:spotfinder/screens/spots-list.screen.dart';
import 'package:spotfinder/screens/take-picture.screen.dart';
import 'package:spotfinder/screens/user-profile-settings.screen.dart';
import 'package:spotfinder/string-methods.dart';
import 'package:spotfinder/widgets/last-pictures.dart';
import 'package:spotfinder/widgets/last-spots.dart';
import 'package:spotfinder/widgets/retry.dart';

class UserProfileScreen extends StatefulWidget {
  static String route = '/user-profile';

  final String userId;

  UserProfileScreen({Key key, @required this.userId}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Future<User> _user;
  User user;
  Future<ResultWrapper<List<Picture>>> _pictures;
  Future<ResultWrapper<List<Spot>>> _spots;
  Future<UserStatistics> _userStatistics;
  bool _isCurrentUser = false;

  @override
  void initState() {
    super.initState();
    this._bindServices();
  }

  void _bindServices() {
    this._user = Repository().getUserById(widget.userId);
    this._pictures = Repository().getUserPicturesWithPending(
        new SearchWithPagination(widget.userId, 1, 9));
    this._spots = Repository().getUserSpotsWithPending(
        new SearchWithPagination(widget.userId, 1, 9), 1, 9);
    this._userStatistics = Repository()
        .getUserStatistics(new SearchWithPagination(widget.userId, 0, 0));
    SharedPrefsHelper.instance.getId().then((String id) {
      setState(() {
        this._isCurrentUser = id == widget.userId;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(capitalize(S.of(context).profile)),
        backgroundColor: Color(0xFF011627),
        actions: [
          Visibility(
            visible: this._isCurrentUser,
            child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => this._openSettingsScreen(),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: this._user,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data;
            this.user = user;

            return this._content(user);
          } else if (snapshot.hasError) {
            return Retry(retryCalled: () => this._retryUserFetch());
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  SingleChildScrollView _content(User user) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 16.0,
          right: 16.0,
          left: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            this._header(),
            // Statistics
            FutureBuilder<UserStatistics>(
              future: this._userStatistics,
              builder: (BuildContext context,
                  AsyncSnapshot<UserStatistics> snapshot) {
                if (snapshot.hasData) {
                  UserStatistics statistics = snapshot.data;

                  return this._statistics(statistics);
                } else if (snapshot.hasError) {
                  return Container();
                } else {
                  return Container(
                    width: double.maxFinite,
                    height: 50.0,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: LastPictures(
                  mediaQueryData: MediaQuery.of(context),
                  displayAllAction: () => this._userPictures(),
                  fetchPicturesService: () => this._pictures),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 24.0,
                bottom: 60.0,
              ),
              child: LastSpots(
                  mediaQueryData: MediaQuery.of(context),
                  displayAllAction: () => this._userSpots(user),
                  fetchSpotsService: () => this._spots),
            ),
          ],
        ),
      ),
    );
  }

  ///
  /// Navigation
  ///

  Future<PicturesDisplayScreen> _userPictures() {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            PicturesDisplayScreen(id: widget.userId, type: PicturesFrom.USER),
      ),
    );
  }

  Future<PicturesDisplayScreen> _displayUserProfilePicture(User user) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => PictureFullScreen(
          pictures: [Picture.fromUser(user)],
          index: 0,
        ),
      ),
    );
  }

  Future<PicturesDisplayScreen> _userSpots(User user) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SpotsListScreen(
          userId: user.id,
        ),
      ),
    );
  }

  Future<UserProfileSettingsScreen> _openSettingsScreen() {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => UserProfileSettingsScreen(
          user: this.user,
        ),
      ),
    );
  }

  void _retryUserFetch() {
    setState(() {
      this._bindServices();
    });
  }

  Widget _header() {
    return Container(
      width: double.maxFinite,
      // color: Colors.red,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100.0,
            height: 100.0,
            child: GestureDetector(
              onTap: () {
                if (user.pictureId != null) {
                  this._displayUserProfilePicture(user);
                } else if (this._isCurrentUser) {
                  this._openTakePictureScreen(context);
                }
              },
              onLongPress: () {
                if (this._isCurrentUser) {
                  this._openTakePictureScreen(context);
                }
              },
              child: FutureBuilder<String>(
                future: SharedPrefsHelper.instance.getToken(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    String token = snapshot.data;

                    if (user.pictureId != null) {
                      return CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        backgroundImage: NetworkImage(
                          '${Constants.getBaseApi()}/picture/id/${this.user.pictureId}',
                          headers: {
                            HttpHeaders.authorizationHeader: 'Bearer $token'
                          },
                        ),
                      );
                    } else {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey[300],
                          ),
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 30.0,
                          ),
                        ],
                      );
                    }
                  } else {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[300],
                        ),
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 30.0,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(
            width: 16.0,
          ),
          Text(
            user.username,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 60.0,
              fontFamily: 'NorthCoast',
            ),
          ),
        ],
      ),
    );
    // );
  }

  Widget _statistics(UserStatistics userStatistics) {
    return Container(
      margin: EdgeInsets.only(
        top: 16.0,
      ),
      // color: Colors.grey[200],
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  '${userStatistics.spots}',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'SPOTS',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NorthCoast',
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '${userStatistics.pictures}',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'PICTURES',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NorthCoast',
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '${userStatistics.comments}',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'COMMENTS',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NorthCoast',
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///
  /// Navigation
  ///
  ///

  void _openTakePictureScreen(BuildContext context) {
    CameraHelper.instance.canUse().then((bool canUse) {
      if (canUse) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => TakePictureScreen(
              takePictureFor: TakePictureFor.USER_PROFILE,
              position: Position(),
              cameraLocation: CameraLocation.FRONT,
            ),
          ),
        );
      } else {
        this.showDialogOpenSettings(
          context,
          Text(S.current.permissionDialogTitle),
          Text(S.current.cameraPermissionMandatory),
        );
      }
    });
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
}
