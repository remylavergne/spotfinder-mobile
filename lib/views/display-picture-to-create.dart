import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spotfinder/repositories/repository.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final Position position;

  DisplayPictureScreen({Key key, @required this.imagePath, this.position})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  TextEditingController spotNameController;
  GlobalKey<FormState> _formKey;
  MediaQueryData mediaQueryData;
  String alertDialogContent = 'Synchronisation du Spot';

  @override
  void initState() {
    this.spotNameController = TextEditingController();
    this._formKey = GlobalKey<FormState>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.mediaQueryData = MediaQuery.of(context);
    AppBar appBar = AppBar(
      title: Text('Création d\'un nouveau spot'),
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
    var dialogState;
    return Container(
      // color: Colors.red[200],
      width: double.infinity,
      margin: EdgeInsets.only(left: 16.0, right: 16.0),
      // alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: mediaQueryData.padding.bottom),
      child: Form(
        key: this._formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextFormField(
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
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext dialogContext) =>
                            StatefulBuilder(builder: (dialogContext, setState) {
                              dialogState = setState;
                              return AlertDialog(
                                title: Text('Création'),
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
                        .createSpot(
                            widget.position, this.spotNameController.text)
                        .then((bool success) {
                      if (success) {
                        dialogState(() {
                          alertDialogContent =
                              'Synchronisation de la photo du Spot';
                        });
                      } else {
                        // todo: display error...
                      }
                    });
                  }
                },
                child: Text(
                  'Créer',
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
