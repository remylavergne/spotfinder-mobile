import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/models/picture.model.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/screens/picture-full.screen.dart';

class LastPictures extends StatelessWidget {
  final MediaQueryData mediaQueryData;
  final Function() displayAllAction;
  final Function() secondAction;
  final Future<ResultWrapper<List<Picture>>> Function() fetchPicturesService;
  final bool secondActionAvailable;

  LastPictures(
      {Key key,
      @required this.mediaQueryData,
      @required this.displayAllAction,
      @required this.fetchPicturesService,
      this.secondAction,
      this.secondActionAvailable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.secondActionAvailable && this.secondAction == null) {
      throw Exception('A getter is mandatory if action is available!');
    }

    double pictureSize = (this.mediaQueryData.size.width - 48.0) / 3;

    return Container(
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
                return this
                    ._generatePicturesWidgets(context, pictures, pictureSize);
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
      BuildContext context, List<Picture> pictures, double size) {
    List<Widget> picturesWidgets = [];
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
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(6.0),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              '${Constants.getBaseApi()}/picture/id/${picture.getThumbnail()}',
              height: size,
              width: size,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

      picturesWidgets.add(w);
    });

    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: 8.0,
        runSpacing: 8.0,
        children: picturesWidgets,
      ),
    );
  }
}
