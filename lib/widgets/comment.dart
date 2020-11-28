import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/models/comment.model.dart';

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
              onTap: () {
                debugPrint('Open user profile => ${this.comment.user.id}');
              },
              leading: CircleAvatar(
                backgroundColor: Colors.red[100],
                backgroundImage: this.comment.user.pictureId != null
                    ? NetworkImage(
                        '${Constants.getBaseApi()}/picture/id/${this.comment.user.pictureId}')
                    : null,
              ),
              title: Text(this.comment.user.username),
              // subtitle: Text(
              //   'Secondary Text',
              //   style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
            Container(
              // color: Colors.red,
              // margin: EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 16.0, left: 16.0, top: 12.0, right: 16.0),
                child: Text(
                  this.comment.message,
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
            ),
          ],
          // ),
          // ),
          // ],
        ),
      ),
    );
  }
}
