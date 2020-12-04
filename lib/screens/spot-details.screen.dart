import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spotfinder/enums/comments-type.enum.dart';
import 'package:spotfinder/helpers/camera.helper.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/enums/take-picture-for.enum.dart';
import 'package:spotfinder/helpers/geolocation.helper.dart';
import 'package:spotfinder/models/comment.model.dart';
import 'package:spotfinder/models/picture.model.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/models/spot.model.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/screens/comment-list.screen.dart';
import 'package:spotfinder/screens/picture-full.screen.dart';
import 'package:spotfinder/screens/pictures-list.screen.dart';
import 'package:spotfinder/services/global-rest.service.dart';
import 'package:spotfinder/screens/take-picture.screen.dart';
import 'package:spotfinder/widgets/comment.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotDetailsScreen extends StatefulWidget {
  static String route = '/spot-details';
  final Spot spot;

  SpotDetailsScreen({Key key, @required this.spot}) : super(key: key);

  @override
  _SpotDetailsScreenState createState() => _SpotDetailsScreenState();
}

class _SpotDetailsScreenState extends State<SpotDetailsScreen> {
  Future<ResultWrapper<List<Picture>>> pictures;
  Future<ResultWrapper<List<Comment>>> comments;

  @override
  void initState() {
    this.pictures =
        RestService().getPaginatedSpotPictures(1, 3, widget.spot.id);
    this.comments =
        Repository().getPaginatedSpotComments(1, 10, widget.spot.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.spot.getSpotName()),
        backgroundColor: Color(0xFF011627),
      ),
      body: SingleChildScrollView(
        child: Container(
          // color: Colors.green,
          child: Column(
            children: [
              this._header(widget.spot, mediaQueryData.size),
              this._generalInformations(widget.spot),
              this._lastPictures(),
              this._lastComments(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(Spot spot, Size screenSize) {
    return Container(
        height: screenSize.height / 4,
        width: double.infinity,
        // color: Colors.red,
        child: Image.network(
            '${Constants.getBaseApi()}/picture/id/${spot.pictureId}',
            fit: BoxFit.cover));
  }

  Widget _generalInformations(Spot spot) {
    return Container(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: 16.0,
      ),
      // color: Colors.blue,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                spot.getSpotName(),
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Text('FakeRunner',
                  style:
                      TextStyle(color: Colors.grey)), // TODO: Open user profile
            ],
          ),
          Container(
              margin: EdgeInsets.only(top: 8.0),
              child: Text(spot.getSpotAddress())),
          FutureBuilder<Position>(
              future: GeolocationHelper.instance.getCurrentPosition(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  Position userPosition = snapshot.data;

                  double distance = GeolocationHelper.instance
                      .getDistanceBetweenToPosition(userPosition,
                          GeolocationHelper.instance.getPositionFromSpot(spot));
                  String realDistance =
                      GeolocationHelper.instance.formatDistance(distance);

                  return Container(
                    margin: EdgeInsets.only(top: 4.0),
                    child: FlatButton(
                      color: Color(0xAAE5E5E5),
                      onPressed: () {
                        this._navigateToSpot(spot);
                      },
                      onLongPress: () {
                        Clipboard.setData(new ClipboardData(
                            text: '${spot.longitude} ${spot.latitude}'));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.directions_run),
                          Text('Distance : '),
                          Text(realDistance),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    margin: EdgeInsets.only(top: 4.0),
                    child: FlatButton(
                      color: Color(0xAAE5E5E5),
                      onPressed: () {
                        this._navigateToSpot(spot);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.directions_run),
                          Text('Voir itinéraire')
                        ],
                      ),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }

  Widget _lastPictures() {
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
                  Text('Dernières photos',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500)),
                  Text(' - '),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              PicturesDisplayScreen(
                                  id: widget.spot.id, type: PicturesFrom.SPOT),
                        ),
                      );
                    },
                    child: Text('Afficher tout',
                        style: TextStyle(
                            fontSize: 14.0, color: Color(0xFF2196F3))),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  //todo: Check all permissions before...
                  this._takeAndAddPicture(context, widget.spot);
                },
                child: Text('+ Ajouter',
                    style: TextStyle(fontSize: 14.0, color: Color(0xFF2196F3))),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 4.0),
            height: 1.0,
            color: Colors.grey,
          ),
          FutureBuilder<ResultWrapper<List<Picture>>>(
            future: this.pictures,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                ResultWrapper<List<Picture>> picturesWrapper = snapshot.data;
                List<Picture> pictures = picturesWrapper.result;

                return this._getLastPicturesWidgets(pictures);
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

  Widget _lastComments() {
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
                  Text('Derniers commentaires',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500)),
                  Text(' - '),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => CommentsScreen(
                              id: widget.spot.id, from: CommentType.SPOT),
                        ),
                      );
                    },
                    child: Text('Afficher tout',
                        style: TextStyle(
                            fontSize: 14.0, color: Color(0xFF2196F3))),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => CommentsScreen(
                        id: widget.spot.id,
                        from: CommentType.SPOT,
                        focusInput: true,
                      ),
                    ),
                  );
                },
                child: Text('+ Ajouter',
                    style: TextStyle(fontSize: 14.0, color: Color(0xFF2196F3))),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 4.0),
            height: 1.0,
            color: Colors.grey,
          ),
          FutureBuilder<ResultWrapper<List<Comment>>>(
            future: this.comments,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                ResultWrapper<List<Comment>> wrapper = snapshot.data;
                List<Comment> comments = wrapper.result;

                return this._getLastCommentsWidget(comments);
              } else if (snapshot.hasError) {
                return CircularProgressIndicator(); // TODO: retry
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

  Container _getLastPicturesWidgets(List<Picture> pictures) {
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
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              '${Constants.getBaseApi()}/picture/id/${picture.id}',
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

  Container _getLastCommentsWidget(List<Comment> comments) {
    if (comments.length == 0) {
      return Container(
        margin: const EdgeInsets.only(top: 8.0),
        child: Center(
          child: Text('Aucun commentaire disponible'),
        ),
      );
    }

    List<CommentWidget> widgets = [];
    comments.forEach((Comment comment) {
      CommentWidget cw = CommentWidget(comment: comment);
      widgets.add(cw);
    });

    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: Column(
        children: widgets,
      ),
    );
  }

  void _takeAndAddPicture(BuildContext context, Spot spot) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => TakePictureScreen(
                  camera: CameraHelper.instance.getCamera(),
                  position:
                      GeolocationHelper.instance.getPositionFromSpot(spot),
                  takePictureFor: TakePictureFor.spot,
                  spotID: spot.id,
                )));
  }

  // TODO: Extract into object
  void _navigateToSpot(Spot spot) async {
    String url;
    if (Platform.isIOS) {
      url = 'https://maps.apple.com/?q=${spot.latitude},${spot.longitude}';
    } else if (Platform.isAndroid) {
      url =
          'https://www.google.com/maps/search/?api=1&query=${spot.latitude},${spot.longitude}';
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
