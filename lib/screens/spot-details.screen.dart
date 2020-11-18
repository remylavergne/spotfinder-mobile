import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/models/picture.model.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/models/spot.model.dart';
import 'package:spotfinder/services/global-rest.service.dart';

class SpotDetailsScreen extends StatefulWidget {
  static String route = '/spot-details';
  final Spot spot;

  SpotDetailsScreen({Key key, @required this.spot}) : super(key: key);

  @override
  _SpotDetailsScreenState createState() => _SpotDetailsScreenState();
}

class _SpotDetailsScreenState extends State<SpotDetailsScreen> {
  Future<ResultWrapper<List<Picture>>> pictures;

  @override
  void initState() {
    this.pictures = RestService().getPaginatedPictures(1, 3, widget.spot.id);
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
              // this._lastComments(),
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
              Text('FakeRunner', style: TextStyle(color: Colors.grey)),
            ],
          ),
          Container(
              margin: EdgeInsets.only(top: 8.0),
              child: Text(spot.getSpotAddress())),
          Container(
            margin: EdgeInsets.only(top: 4.0),
            child: FlatButton(
              onPressed: () {
                debugPrint('Navigate to Spot');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.directions_run),
                  Text('Distance : '),
                  Text('3,2 km'),
                ],
              ),
            ),
          ),
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
                      debugPrint('Display all pictures');
                    },
                    child: Text('Afficher tout',
                        style: TextStyle(
                            fontSize: 14.0, color: Color(0xFF2196F3))),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  debugPrint('Add new picture to spot');
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
                print('');
                return CircularProgressIndicator();
              } else {
                return CircularProgressIndicator();
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
        top: 16.0,
        bottom: 16.0,
      ),
      // color: Colors.orange[200],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Derniers commentaires - '),
                  Text('Afficher tout')
                ],
              ),
              Text('+ Ajouter'),
            ],
          ),
          Container(
            height: 1.0,
            color: Colors.grey,
          ),
          FutureBuilder<List<Widget>>(
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<Picture> pictures = snapshot.data;
                return this._getLastCommentsWidgets(pictures);
              } else if (snapshot.hasError) {
                print('');
                return CircularProgressIndicator();
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }

  Container _getLastPicturesWidgets(List<Picture> pictures) {
    List<Widget> picturesWidgets = [];
    // todo: taille des images en fonction de la taille de l'écran ! => MediaQueryData
    pictures.forEach((Picture picture) {
      Widget w = Container(
          width: 120.0,
          height: 120.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            // border: Border.all(color: Colors.black, width: 0.5),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                '${Constants.getBaseApi()}/picture/id/${picture.id}',
                height: 120.0,
                width: 120.0,
                fit: BoxFit.cover,
              )));

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

  Row _getLastCommentsWidgets(List<Picture> pictures) {
    // todo refactor
    List<Widget> picturesWidgets = [];

    pictures.forEach((Picture picture) {
      Widget w = Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network(
              '${Constants.getBaseApi()}/picture/id/${picture.id}',
              fit: BoxFit.cover));

      picturesWidgets.add(w);
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: picturesWidgets,
    );
  }
}
