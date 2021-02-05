import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/models/comment.model.dart';
import 'package:spotfinder/screens/user-profile.screen.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;
  CommentWidget({Key key, @required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              tileColor: Color(0xAAE5E5E5),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        UserProfileScreen(userId: this.comment.userId),
                  ),
                );
              },
              leading: FutureBuilder<String>(
                future: SharedPrefsHelper.instance.getToken(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    String token = snapshot.data;
                    return CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      backgroundImage: this.comment.user.pictureId != null
                          ? NetworkImage(
                              '${Constants.getBaseApi()}/picture/id/${this.comment.user.getThumbnail()}',
                              headers: {
                                HttpHeaders.authorizationHeader: 'Bearer $token'
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
              title: Text(
                this.comment.user.username,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 4.0, left: 16.0, top: 16.0, right: 16.0),
                    child: Text(
                      this.comment.message,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 4.0,
                      right: 8.0,
                    ),
                    child: Text(
                      this._formatDate(this.comment.createdAt),
                      style: TextStyle(color: Colors.grey[500], fontSize: 12.0),
                    ),
                  ),
                ),
              ],
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
