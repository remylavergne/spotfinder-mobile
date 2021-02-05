import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
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
      body: Container(
        child: Stack(
          children: [
            FutureBuilder<String>(
              future: SharedPrefsHelper.instance.getToken(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  String token = snapshot.data;
                  return SizedBox.expand(
                    child: Image.network(
                      '${Constants.getBaseApi()}/picture/id/${picture.id}',
                      headers: {
                        HttpHeaders.authorizationHeader: 'Bearer $token'
                      },
                      fit: BoxFit.cover,
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.maxFinite,
                height: 80.0,
                color: Color(0x66011627),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // TODO: Open profile
                        debugPrint('Open profile');
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          left: 8.0,
                        ),
                        width: double.maxFinite,
                        child: Text(
                          'Rémy Lavergne', // TODO: Adapter
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
                          this._formatDate(this.picture.createdAt),
                          style: TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
