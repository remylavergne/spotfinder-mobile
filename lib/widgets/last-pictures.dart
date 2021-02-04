import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/models/picture.model.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/screens/picture-full.screen.dart';
import 'package:spotfinder/widgets/retry.dart';
import 'package:spotfinder/widgets/square-photo-item.dart';

class LastPictures extends StatefulWidget {
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
  _LastPicturesState createState() => _LastPicturesState();
}

class _LastPicturesState extends State<LastPictures> {
  bool _canDisplayAll = false;
  Future<ResultWrapper<List<Picture>>> _pictures;

  @override
  void initState() {
    super.initState();
    this._pictures = this.widget.fetchPicturesService();
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.secondActionAvailable && this.widget.secondAction == null) {
      throw Exception('A getter is mandatory if action is available!');
    }

    double pictureSize = (this.widget.mediaQueryData.size.width - 58.0) / 3;

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
                      if (this._canDisplayAll) {
                        this.widget.displayAllAction();
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 8.0, right: 16.0),
                      child: Text(
                        S.current.displayAll,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: this.widget.secondActionAvailable,
                child: GestureDetector(
                  onTap: () {
                    this.widget.secondAction();
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 8.0, left: 16.0),
                    child: Text(
                      S.current.addAction,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF2196F3),
                      ),
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
            future: this._pictures,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                ResultWrapper<List<Picture>> picturesWrapper = snapshot.data;
                List<Picture> pictures = picturesWrapper.result;
                return this
                    ._generatePicturesWidgets(context, pictures, pictureSize);
              } else if (snapshot.hasError) {
                return Retry(retryCalled: () => this._retryPicturesFetch());
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
    if (pictures.isEmpty) {
      return Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(S.of(context).noPictureItem),
          ),
        ),
      );
    }

    this._canDisplayAll = true;

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
        child: SquarePhotoItem(
          url: '${Constants.getBaseApi()}/picture/id/${picture.getThumbnail()}',
          size: size,
          isPending: picture.isPending(),
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

  void _retryPicturesFetch() {
    setState(() {
      this.widget.fetchPicturesService();
    });
  }
}
