import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        .getUserPictures(new SearchWithPagination(widget.userId, 1, 40));
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

            return this._content();
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

  SingleChildScrollView _content() {
    return SingleChildScrollView(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Profil utilisateur'),
          LastPictures(
              displayAllAction: () => this._userPictures(),
              secondAction: null,
              fetchPicturesService: () => this._pictures)
        ],
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
