import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';

class SquarePhotoItem extends StatelessWidget {
  final double size;
  final String url;

  SquarePhotoItem({Key key, @required this.url, @required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: SharedPrefsHelper.instance.getToken(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          String token = snapshot.data;
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                url,
                headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
                height: size,
                width: size,
                fit: BoxFit.cover,
              ),
            ),
          );
        } else {
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                color: Colors.grey[300],
                height: size,
                width: size,
              ),
            ),
          );
        }
      },
    );
  }
}
