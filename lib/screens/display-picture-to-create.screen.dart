import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spotfinder/enums/take-picture-for.enum.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';
import 'package:spotfinder/repositories/repository.dart';

class DisplayPictureScreen extends StatefulWidget {
  static String route = '/display-picture';
  final String imagePath;
  final Position position;
  final TakePictureFor takePictureFor;
  final String spotID;

  DisplayPictureScreen(
      {Key key,
      @required this.imagePath,
      @required this.position,
      @required this.takePictureFor,
      this.spotID})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  TextEditingController spotNameController;
  GlobalKey<FormState> _formKey;
  MediaQueryData mediaQueryData;
  String alertDialogContent = 'Synchronisation du Spot';
  String idUser;
  void Function(void Function()) dialogState;

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
      title: Text(widget.takePictureFor == TakePictureFor.creation
          ? 'Création d\'un nouveau spot'
          : 'Ajouter une photo'),
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
              visible: widget.takePictureFor == TakePictureFor.creation,
              child: TextFormField(
                controller: this.spotNameController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Color(0xFF989898),
                    fontSize: 18.0,
                  ),
                  hintText: 'Nom du spot (facultatif)',
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
                      case TakePictureFor.creation:
                        this._spotCreationFlow(context);
                        break;
                      case TakePictureFor.spot:
                        this._addPictureFlow(context);
                        break;
                      default:
                        throw Exception('Unknown flow picture');
                    }
                  }
                },
                child: Text(
                  widget.takePictureFor == TakePictureFor.creation
                      ? 'Créer'
                      : 'Ajouter', // todo: update texte
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
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext dialogContext) =>
            StatefulBuilder(builder: (dialogContext, setState) {
              this.dialogState = setState;
              return AlertDialog(
                title: Center(child: Text('Création')), // todo: update text
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(alertDialogContent),
                  ],
                ),
              );
            }));

    Repository()
        .createSpot(widget.position, this.spotNameController.text.trim())
        .then((String idSpot) {
      if (idSpot != null) {
        dialogState(() {
          alertDialogContent = 'Synchronisation de la photo du Spot';
        });
        return Repository()
            .uploadPicture(idSpot, idUser, File(widget.imagePath));
      } else {
        dialogState(() {
          alertDialogContent =
              'Erreur pendant la création. Retour à l\'accueil.';
        });
        this._returnToHome(context);
      }
    }).then((bool imageUploaded) async {
      if (imageUploaded) {
        dialogState(() {
          alertDialogContent = 'Création validée';
        });
        this._returnToHome(context);
      } else {
        dialogState(() {
          alertDialogContent =
              'Erreur pendant la création. Retour à l\'accueil.';
        });
        this._returnToHome(context);
      }
    });
  }

  void _addPictureFlow(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext dialogContext) =>
            StatefulBuilder(builder: (dialogContext, setState) {
              this.dialogState = setState;
              this.alertDialogContent = 'Envoi de l\'image en cours...';
              return AlertDialog(
                title: Center(child: Text('Ajout d\'une photo')),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(this.alertDialogContent),
                  ],
                ),
              );
            }));

    Repository()
        .uploadPicture(widget.spotID, idUser, File(widget.imagePath))
        .then((bool uploadSuccess) {
      if (uploadSuccess) {
        this.dialogState(() {
          this.alertDialogContent = 'La photo a bien été ajoutée au Spot.';
        });
        this._returnToTakePictureScreen(context);
      } else {
        this.dialogState(() {
          this.alertDialogContent =
              'Erreur à l\'ajout de la photo. Réessayez plus tard.';
        });
        this._returnToTakePictureScreen(context);
      }
    });
  }

  void _returnToHome(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  void _returnToTakePictureScreen(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pop(context);
    Navigator.pop(context);
  }
}