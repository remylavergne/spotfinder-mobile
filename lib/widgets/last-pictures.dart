import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/models/picture.model.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/screens/picture-full.screen.dart';

class LastPictures extends StatelessWidget {
  final Function() displayAllAction;
  final Function() secondAction;
  final Future<ResultWrapper<List<Picture>>> Function() fetchPicturesService;
  final bool secondActionAvailable;

  LastPictures(
      {Key key,
      @required this.displayAllAction,
      @required this.secondAction,
      @required this.fetchPicturesService,
      this.secondActionAvailable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.secondActionAvailable && this.secondAction == null) {
      throw Exception('A getter is mandatory if action is available!');
    }

    return Container(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        // top: 8.0,
        bottom: 16.0,
      ),
      // color: Colors.red[200],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Text(
                    S.current.latestPhotos,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                  Text(' - '),
                  GestureDetector(
                    onTap: () {
                      this.displayAllAction();
                    },
                    child: Text(
                      S.current.displayAll,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: this.secondActionAvailable,
                child: GestureDetector(
                  onTap: () {
                    this.secondAction();
                  },
                  child: Text(
                    S.current.addAction,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 4.0),
            height: 1.0,
            color: Colors.grey,
          ),
          FutureBuilder<ResultWrapper<List<Picture>>>(
            future: this.fetchPicturesService(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                ResultWrapper<List<Picture>> picturesWrapper = snapshot.data;
                List<Picture> pictures = picturesWrapper.result;
                return this._generatePicturesWidgets(context, pictures);
              } else if (snapshot.hasError) {
                return Padding(
                  // TODO: Retry
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Container _generatePicturesWidgets(
      BuildContext context, List<Picture> pictures) {
    List<Widget> picturesWidgets = [];
    // TODO: taille des images en fonction de la taille de l'écran ! => MediaQueryData
    pictures.forEach((Picture picture) {
      Widget w = GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  PictureFullScreen(picture: picture),
            ),
          );
        },
        child: Container(
          width: 120.0,
          height: 120.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(6.0),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              '${Constants.getBaseApi()}/picture/id/${picture.getThumbnail()}',
              height: 120.0,
              width: 120.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

      picturesWidgets.add(w);
    });

    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: picturesWidgets,
      ),
    );
  }
}
