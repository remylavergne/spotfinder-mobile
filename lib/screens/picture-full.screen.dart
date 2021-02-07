import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/models/picture.model.dart';
import 'package:spotfinder/models/user.model.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/screens/user-profile.screen.dart';

class PictureFullScreen extends StatefulWidget {
  static String route = '/picture-fullscreen';
  final List<Picture> pictures;
  final int index;
  PictureFullScreen({Key key, @required this.pictures, @required this.index})
      : super(key: key);

  @override
  _PictureFullScreenState createState() => _PictureFullScreenState();
}

class _PictureFullScreenState extends State<PictureFullScreen> {
  bool _visible = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double informationsContainerHeight = 56.0 + mediaQueryData.padding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.photoTitle),
        backgroundColor: Color(0xFF011627),
      ),
      body: Container(
        child: FutureBuilder<String>(
          future: SharedPrefsHelper.instance.getToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              String token = snapshot.data;

              return PageView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return this._body(
                    this.widget.pictures[index],
                    token,
                    informationsContainerHeight,
                  );
                },
                itemCount: this.widget.pictures.length,
              );
            } else {
              return SizedBox.expand(
                child: Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _body(Picture picture, String token, double widgetHeight) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _visible = !_visible;
            });
          },
          child: SizedBox.expand(
            child: Image.network(
              '${Constants.getBaseApi()}/picture/id/${picture.id}',
              headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Picture informations
        FutureBuilder(
          future: Repository().getUserById(picture.userId),
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            if (snapshot.hasData) {
              User user = snapshot.data;

              return AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 400),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.maxFinite,
                    height: widgetHeight,
                    color: Color(0x88011627),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    UserProfileScreen(userId: user.id),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              left: 8.0,
                            ),
                            width: double.maxFinite,
                            child: Text(
                              user.username,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                          child: Container(
                            width: double.maxFinite,
                            child: Text(
                              this._formatDate(picture.createdAt),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }

  String _formatDate(int timeInMillis) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
    String formattedDate = DateFormat.yMMMd().format(date);
    return formattedDate;
  }
}
