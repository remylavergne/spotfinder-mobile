import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/models/dto/search-with-pagination.dto.dart';
import 'package:spotfinder/models/picture.model.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/models/user.model.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/screens/pictures-list.screen.dart';
import 'package:spotfinder/widgets/last-pictures.dart';

class UserProfileScreen extends StatefulWidget {
  static String route = '/user-profile';

  final String userId;

  UserProfileScreen({Key key, @required this.userId}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Future<User> _user;
  User user;
  Future<ResultWrapper<List<Picture>>> _pictures;

  @override
  void initState() {
    this._user = Repository().getUserById(widget.userId);
    this._pictures = Repository()
        .getUserPictures(new SearchWithPagination(widget.userId, 1, 9));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).profileTitle),
        backgroundColor: Color(0xFF011627),
      ),
      body: FutureBuilder(
        future: this._user,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data;
            this.user = user;

            return this._content(user);
          } else if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text('ERROR'), // TODO: Retry action
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
    );
  }

  SingleChildScrollView _content(User user) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 16.0,
          right: 16.0,
          left: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      backgroundImage: user.pictureId != null
                          ? NetworkImage(
                              '${Constants.getBaseApi()}/picture/id/${this.user.pictureId}')
                          : null,
                    ),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Text(
                    user.username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 60.0,
                      fontFamily: 'NorthCoast',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: LastPictures(
                  mediaQueryData: MediaQuery.of(context),
                  displayAllAction: () => this._userPictures(),
                  fetchPicturesService: () => this._pictures),
            )
          ],
        ),
      ),
    );
  }

  Future<PicturesDisplayScreen> _userPictures() {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            PicturesDisplayScreen(id: widget.userId, type: PicturesFrom.USER),
      ),
    );
  }
}
