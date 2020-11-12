import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/repositories/repository.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  DisplayPictureScreen({Key key, @required this.imagePath}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  TextEditingController spotNameController;
  GlobalKey<FormState> _formKey;
  bool _isLoading = false;
  MediaQueryData mediaQueryData;

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
          Visibility(
              visible: this._isLoading,
              child: this._loadingScreen(
                  this.mediaQueryData, appBar.preferredSize.height))
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
                    setState(() {
                      _showLoadingScreen();
                    });
                    Repository().uploadPicture(File(widget.imagePath));
                    // TODO: upload picture
                    // TODO: create Spot
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

  Widget _loadingScreen(MediaQueryData mediaQuery, double appBarHeight) {
    double marginTop = ((mediaQuery.size.height -
                (appBarHeight + mediaQueryData.padding.top)) /
            2) -
        25.0;
    double marginLeft = (mediaQuery.size.width / 2) - 25.0;

    return Container(
      color: Color(0xAB011627),
      child: AspectRatio(
        aspectRatio: mediaQuery.size.aspectRatio,
        child: Container(
          margin: EdgeInsets.only(
              top: marginTop,
              left: marginLeft,
              bottom: marginTop,
              right: marginLeft),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _showLoadingScreen() {
    this._isLoading = true;
  }

  Widget _hideLoadingScreen() {
    this._isLoading = false;
  }
}
