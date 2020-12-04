import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/enums/comments-from.enum.dart';
import 'package:spotfinder/models/comment.model.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/widgets/comment.dart';

class CommentsScreen extends StatefulWidget {
  final String id;
  final CommentsFrom from;

  CommentsScreen({Key key, @required this.id, @required this.from})
      : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  Future<ResultWrapper<List<Comment>>> comments;

  @override
  void initState() {
    this.comments = Repository().getPaginatedSpotComments(1, 30, widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commentaires'),
        backgroundColor: Color(0xFF011627),
      ),
      body: FutureBuilder<ResultWrapper<List<Comment>>>(
        future: this.comments,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            ResultWrapper<List<Comment>> wrapper = snapshot.data;
            List<Comment> comments = wrapper.result;

            return this._getLastCommentsWidget(comments);
          } else if (snapshot.hasError) {
            return Container(
                child:
                    Center(child: CircularProgressIndicator())); // TODO: retry
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _getLastCommentsWidget(List<Comment> comments) {
    if (comments.length == 0) {
      return Container(
        margin: const EdgeInsets.only(top: 8.0),
        child: Center(
          child: Text('Aucun commentaire disponible'),
        ),
      );
    }

    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (BuildContext context, int index) {
        return CommentWidget(comment: comments[index]);
    });
  }
}
