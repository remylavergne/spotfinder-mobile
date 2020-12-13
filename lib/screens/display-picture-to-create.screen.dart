import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spotfinder/enums/take-picture-for.enum.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/helpers/navigator.helper.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/models/dto/update-user-profile.dto.dart';
import 'package:spotfinder/models/picture.model.dart';
import 'package:spotfinder/models/user.model.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/screens/feed.screen.dart';
import 'package:spotfinder/widgets/upload-dialog.dart';

class DisplayPictureScreen extends StatefulWidget {
  static final String route = '/display-picture';
  final String imagePath;
  final Position position;
  final TakePictureFor takePictureFor;
  final String id;

  DisplayPictureScreen(
      {Key key,
      @required this.imagePath,
      @required this.position,
      @required this.takePictureFor,
      this.id})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  TextEditingController spotNameController;
  GlobalKey<FormState> _formKey;
  MediaQueryData mediaQueryData;
  String idUser;

  @override
  void initState() {
    this.spotNameController = TextEditingController();
    this._formKey = GlobalKey<FormState>();
    SharedPrefsHelper.instance
        .getId()
        .then((String idUser) => this.idUser = idUser);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.mediaQueryData = MediaQuery.of(context);
    AppBar appBar = AppBar(
      title: Text(widget.takePictureFor == TakePictureFor.CREATION
          ? S.current.createSpotTitle
          : S.current.addPictureTitle),
      backgroundColor: Color(0xFF011627),
    );

    return Scaffold(
      appBar: appBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.blue,
            child: Image.file(
              File(widget.imagePath),
              fit: BoxFit.fill,
            ),
          ),
          this._actionsButtons(context),
        ],
      ),
    );
  }

  Widget _actionsButtons(BuildContext context) {
    return Container(
      // color: Colors.red[200],
      width: double.infinity,
      margin: EdgeInsets.only(left: 16.0, right: 16.0),
      // alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: mediaQueryData.padding.bottom + 16.0),
      child: Form(
        key: this._formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: widget.takePictureFor == TakePictureFor.CREATION,
              child: TextFormField(
                controller: this.spotNameController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Color(0xFF989898),
                    fontSize: 18.0,
                  ),
                  hintText: S.current.spotNameHint,
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => null,
              ),
            ),
            Container(
              width: 180.0,
              margin: EdgeInsets.only(top: 16.0),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                color: Color(0xFF276FBF),
                textColor: Colors.white,
                height: 56.0,
                onPressed: () {
                  if (this._formKey.currentState.validate()) {
                    switch (widget.takePictureFor) {
                      case TakePictureFor.CREATION:
                        this._spotCreationFlow(context);
                        break;
                      case TakePictureFor.SPOT:
                        this._addPictureFlow(context);
                        break;
                      case TakePictureFor.USER_PROFILE:
                        this._addProfilePictureFlow(context);
                        break;
                      default:
                        throw Exception('Unknown flow picture');
                    }
                  }
                },
                child: Text(
                  widget.takePictureFor == TakePictureFor.CREATION
                      ? S.current.create
                      : S.current.add, // todo: update texte
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Business
  void _spotCreationFlow(BuildContext context) {
    UploadDialog uploadDialog =
        new UploadDialog(context, S.of(context).synchroInProgress).show();

    Repository()
        .createSpot(widget.position, this.spotNameController.text.trim())
        .then((String idSpot) {
      if (idSpot != null) {
        uploadDialog.updateText(S.current.pictureIsBeingSynchronized);
        return Repository()
            .uploadPicture(idSpot, idUser, File(widget.imagePath));
      } else {
        uploadDialog.updateText(S.current.errorSpotCreation);
        this._returnToHome(context);
      }
    }).then((Picture picture) async {
      if (picture != null) {
        uploadDialog.updateText(S.current.spotCreationSuccess);
        this._returnToHome(context);
      } else {
        uploadDialog.updateText(S.current.errorSpotCreation);
        this._returnToHome(context);
      }
    });
  }

  void _addPictureFlow(BuildContext context) {
    UploadDialog uploadDialog =
        new UploadDialog(context, S.of(context).synchroInProgress).show();

    Repository()
        .uploadPicture(widget.id, idUser, File(widget.imagePath))
        .then((Picture picture) {
      if (picture != null) {
        uploadDialog.updateText(S.current.errorSpotCreation);
        this._returnToTakePictureScreen(context);
      } else {
        uploadDialog.updateText(S.current.addPhotoSuccess);
        this._returnToTakePictureScreen(context);
      }
    });
  }

  void _addProfilePictureFlow(BuildContext context) {
    UploadDialog uploadDialog =
        new UploadDialog(context, S.of(context).pictureIsBeingSynchronized)
            .show();

    Repository()
        .uploadPicture(idUser, idUser, File(widget.imagePath))
        .then((Picture picture) {
      if (picture != null) {
        return Repository()
            .updateUserProfile(new UpdateUserProfile(idUser, picture.id));
      } else {
        uploadDialog.updateText(S.current.errorPhotoUpload);
        this._returnToProfile(context);
      }
    }).then((User user) {
      if (user == null) {
        uploadDialog.updateText(S.current.errorUpdateProfilePicture);
      } else {
        uploadDialog.updateText(S.current.profilePictureUploaded);
      }
      this._returnToProfile(context);
    });
  }

  void _returnToHome(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushNamedAndRemoveUntil(context, FeedScreen.route, (r) => false);
  }

  void _returnToTakePictureScreen(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    NavigatorHelper.instance.popTimes(2, context);
  }

  void _returnToProfile(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    NavigatorHelper.instance.popTimes(3, context);
  }
}
