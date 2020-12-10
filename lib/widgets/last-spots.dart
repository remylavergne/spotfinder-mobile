import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/models/spot.model.dart';
import 'package:spotfinder/screens/spot-details.screen.dart';
import 'package:spotfinder/widgets/square-photo-item.dart';

class LastSpots extends StatelessWidget {
  final MediaQueryData mediaQueryData;
  final Function() displayAllAction;
  final Function() secondAction;
  final Future<ResultWrapper<List<Spot>>> Function() fetchSpotsService;
  final bool secondActionAvailable;

  LastSpots(
      {Key key,
      @required this.mediaQueryData,
      @required this.displayAllAction,
      @required this.fetchSpotsService,
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
                    S.of(context).latestSpots,
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
          FutureBuilder<ResultWrapper<List<Spot>>>(
            future: this.fetchSpotsService(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                ResultWrapper<List<Spot>> spotWrapper = snapshot.data;
                List<Spot> spots = spotWrapper.result;
                return this._generateSpotsWidgets(context, spots, pictureSize);
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

  Container _generateSpotsWidgets(
      BuildContext context, List<Spot> spots, double size) {
    if (spots.isEmpty) {
      return Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('No spot yet'),
          ), // TODO: Translate
        ),
      );
    }

    List<Widget> picturesWidgets = [];
    spots.forEach((Spot spot) {
      Widget w = GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => SpotDetailsScreen(
                spot: spot,
              ),
            ),
          );
        },
        child: SquarePhotoItem(
          url: '${Constants.getBaseApi()}/picture/id/${spot.getThumbnail()}',
          size: size,
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
