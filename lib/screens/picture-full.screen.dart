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

class PictureFullScreen extends StatefulWidget {
  static String route = '/picture-fullscreen';
  final Picture picture;
  PictureFullScreen({Key key, @required this.picture}) : super(key: key);

  @override
  _PictureFullScreenState createState() => _PictureFullScreenState();
}

class _PictureFullScreenState extends State<PictureFullScreen> {
  Future<User> _user;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    this._user = Repository().getUserById(this.widget.picture.userId);
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
        child: Stack(
          children: [
            FutureBuilder<String>(
              future: SharedPrefsHelper.instance.getToken(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  String token = snapshot.data;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _visible = !_visible;
                      });
                    },
                    child: SizedBox.expand(
                      child: Image.network(
                        '${Constants.getBaseApi()}/picture/id/${widget.picture.id}',
                        headers: {
                          HttpHeaders.authorizationHeader: 'Bearer $token'
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
            FutureBuilder<User>(
              future: this._user,
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
                        height: informationsContainerHeight,
                        color: Color(0x88011627),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // TODO: Open profile // Check if not already opened
                                debugPrint('Open profile');
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
                              padding:
                                  const EdgeInsets.only(top: 4.0, left: 8.0),
                              child: Container(
                                width: double.maxFinite,
                                child: Text(
                                  this._formatDate(
                                      this.widget.picture.createdAt),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10.0),
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
        ),
      ),
    );
  }

  String _formatDate(int timeInMillis) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
    String formattedDate = DateFormat.yMMMd().format(date);
    return formattedDate;
  }
}
