import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/models/picture.model.dart';

class PictureFullScreen extends StatelessWidget {
  static String route = '/picture-fullscreen';
  final Picture picture;
  PictureFullScreen({Key key, @required this.picture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.photoTitle),
        backgroundColor: Color(0xFF011627),
      ),
      body: FutureBuilder<String>(
          future: SharedPrefsHelper.instance.getToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              String token = snapshot.data;
              return Container(
                width: double.maxFinite,
                height: double.maxFinite,
                child: Image.network(
                  '${Constants.getBaseApi()}/picture/id/${picture.id}',
                  headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
                  fit: BoxFit.fill,
                ),
              );
            } else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }
}
