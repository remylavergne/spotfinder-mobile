import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/models/dto/search-with-pagination.dto.dart';
import 'package:spotfinder/models/picture.model.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/models/spot.model.dart';
import 'package:spotfinder/models/user.model.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/screens/picture-full.screen.dart';
import 'package:spotfinder/screens/pictures-list.screen.dart';
import 'package:spotfinder/screens/spots-list.screen.dart';
import 'package:spotfinder/screens/user-profile-settings.screen.dart';
import 'package:spotfinder/string-methods.dart';
import 'package:spotfinder/widgets/last-pictures.dart';
import 'package:spotfinder/widgets/last-spots.dart';
import 'package:spotfinder/widgets/retry.dart';

class UserProfileScreen extends StatefulWidget {
  static String route = '/user-profile';

  final String userId;
  final bool isCurrentUser;

  UserProfileScreen(
      {Key key, @required this.userId, @required this.isCurrentUser})
      : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Future<User> _user;
  User user;
  Future<ResultWrapper<List<Picture>>> _pictures;
  Future<ResultWrapper<List<Spot>>> _spots;

  @override
  void initState() {
    this._bindServices();
    super.initState();
  }

  void _bindServices() {
    this._user = Repository().getUserById(widget.userId);
    this._pictures = Repository()
        .getUserPictures(new SearchWithPagination(widget.userId, 1, 9));
    this._spots = Repository()
        .getUserSpots(new SearchWithPagination(widget.userId, 1, 9));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(capitalize(S.of(context).profile)),
        backgroundColor: Color(0xFF011627),
        actions: [
          Visibility(
            visible: widget.isCurrentUser,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 80.0,
                    height: 80.0,
                    child: GestureDetector(
                      onTap: () {
                        if (user.pictureId != null) {
                          this._displayUserProfilePicture(user);
                        }
                      },
                      child: FutureBuilder<String>(
                        future: SharedPrefsHelper.instance.getToken(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            String token = snapshot.data;
                            return CircleAvatar(
                              backgroundColor: Colors.grey[100],
                              backgroundImage: user.pictureId != null
                                  ? NetworkImage(
                                      '${Constants.getBaseApi()}/picture/id/${this.user.pictureId}',
                                      headers: {
                                        HttpHeaders.authorizationHeader:
                                            'Bearer $token'
                                      },
                                    )
                                  : null,
                            );
                          } else {
                            return CircleAvatar(
                              backgroundColor: Colors.grey[100],
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
          picture: Picture.fromUser(user),
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
        builder: (BuildContext context) => UserProfileSettingsScreen(),
      ),
    );
  }

  void _retryUserFetch() {
    setState(() {
      this._bindServices();
    });
  }
}
