import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/enums/comments-type.enum.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/models/comment.model.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/widgets/comment.dart';
import 'package:spotfinder/widgets/retry.dart';

class CommentsScreen extends StatefulWidget {
  final String id;
  final CommentType from;
  final bool focusInput;

  CommentsScreen(
      {Key key,
      @required this.id,
      @required this.from,
      this.focusInput = false})
      : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  Future<ResultWrapper<List<Comment>>> comments;
  TextEditingController messageCtrl;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode focusNode;
  // True if a new message has been added. At least.
  bool newMessage = false;

  @override
  void initState() {
    this.comments = Repository().getPaginatedSpotComments(1, 30, widget.id);
    this.messageCtrl = TextEditingController();
    this.focusNode = FocusNode();
    if (widget.focusInput) {
      this.focusNode.requestFocus();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    bool displayError = false;

    return WillPopScope(
      onWillPop: () {
        return this._onPopAction(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.current.comments),
          backgroundColor: Color(0xFF011627),
        ),
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              FutureBuilder<ResultWrapper<List<Comment>>>(
                future: this.comments,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    ResultWrapper<List<Comment>> wrapper = snapshot.data;
                    List<Comment> comments = wrapper.result;

                    return this._getLastCommentsWidget(comments);
                  } else if (snapshot.hasError) {
                    return Retry(retryCalled: () => this._fetchRetry());
                  } else {
                    return Expanded(
                      child: Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                },
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFF011627),
                      width: 2.0,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(
                    left: 4.0, bottom: mediaQueryData.padding.bottom + 16.0),
                child: Form(
                  key: this._formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                            focusNode: this.focusNode,
                            controller: this.messageCtrl,
                            validator: (value) {
                              if (value.length < 1) {
                                displayError = true;
                                return 'Message have to contains 1 characters at least';
                              } else {
                                displayError = false;
                                return null;
                              }
                            },
                            onChanged: (value) {
                              if (displayError) {
                                displayError = false;
                                this._formKey.currentState.validate();
                              }
                            },
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: true,
                              hintText: S.current.typeCommentHint,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                        ),
                        // Button to send message
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: FlatButton(
                              onPressed: () async {
                                if (this._formKey.currentState.validate() &&
                                    this.messageCtrl.text.trim().length >= 5) {
                                  await Repository()
                                      .sendComment(this.messageCtrl.text.trim(),
                                          CommentType.SPOT, widget.id)
                                      .then((bool added) {
                                    if (added) {
                                      setState(() {
                                        this.focusNode.unfocus();
                                        this.messageCtrl.clear();
                                        this.comments = Repository()
                                            .getPaginatedSpotComments(
                                                1, 30, widget.id);
                                        this.newMessage = true;
                                      });
                                    }
                                  });
                                } else {
                                  displayError = true;
                                }
                              },
                              child: Text(
                                S.current.send,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onPopAction(BuildContext context) {
    Navigator.of(context).pop(this.newMessage);
    return Future.value(true);
  }

  void _fetchRetry() {
    setState(() {
      this.comments = Repository().getPaginatedSpotComments(1, 30, widget.id);
    });
  }

  Widget _getLastCommentsWidget(List<Comment> comments) {
    if (comments.length == 0) {
      return Expanded(
        child: Container(
          child: Center(
            child: Text(S.current.noComment),
          ),
        ),
      );
    }

    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        ),
        child: ListView.builder(
            itemCount: comments.length,
            itemBuilder: (BuildContext context, int index) {
              return CommentWidget(comment: comments[index]);
            }),
      ),
    );
  }
}
