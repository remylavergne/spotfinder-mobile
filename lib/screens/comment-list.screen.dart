import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/enums/comments-type.enum.dart';
import 'package:spotfinder/models/comment.model.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/widgets/comment.dart';

class CommentsScreen extends StatefulWidget {
  final String id;
  final CommentType from;

  CommentsScreen({Key key, @required this.id, @required this.from})
      : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  Future<ResultWrapper<List<Comment>>> comments;
  TextEditingController messageCtrl;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode focusNode;

  @override
  void initState() {
    this.comments = Repository().getPaginatedSpotComments(1, 30, widget.id);
    this.messageCtrl = TextEditingController();
    this.focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Commentaires'),
        backgroundColor: Color(0xFF011627),
      ),
      body: Container(
        child: Stack(children: [
          FutureBuilder<ResultWrapper<List<Comment>>>(
            future: this.comments,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                ResultWrapper<List<Comment>> wrapper = snapshot.data;
                List<Comment> comments = wrapper.result;

                return this._getLastCommentsWidget(comments);
              } else if (snapshot.hasError) {
                return Container(
                    child: Center(
                        child: CircularProgressIndicator())); // TODO: retry
              } else {
                return Container(
                  // padding: const EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
          // Writing zone
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFF011627),
                      width: 2.0,
                    ),
                  )),
              padding: EdgeInsets.only(
                  left: 4.0, bottom: mediaQueryData.padding.bottom + 16.0),
              child: Form(
                key: this._formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 3,
                        focusNode: this.focusNode,
                        controller: this.messageCtrl,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: true,
                          hintText: 'Tapez votre commentaire ici',
                          fillColor: Colors.grey[100],
                        ),
                      ),
                    )),
                    FlatButton(
                      onPressed: () async {
                        debugPrint('Send comment');
                        if (this._formKey.currentState.validate() &&
                            this.messageCtrl.text.trim().length > 5) {
                          await Repository()
                              .sendComment(this.messageCtrl.text.trim(),
                                  CommentType.SPOT, widget.id)
                              .then((bool added) {
                            if (added) {
                              setState(() {
                                this.focusNode.unfocus();
                                this.messageCtrl.clear();
                                this.comments = Repository()
                                    .getPaginatedSpotComments(1, 30, widget.id);
                              });
                            }
                          });
                        }
                      },
                      child: Text('Envoyer', style: TextStyle(fontWeight: FontWeight.bold),),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),
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

    return Container(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 100.0,
      ),
      child: ListView.builder(
          itemCount: comments.length,
          itemBuilder: (BuildContext context, int index) {
            return CommentWidget(comment: comments[index]);
          }),
    );
  }
}
