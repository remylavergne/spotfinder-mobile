import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/models/dto/search-with-pagination.dto.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/models/spot.model.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/screens/spot-details.screen.dart';
import 'package:spotfinder/widgets/retry.dart';
import 'package:spotfinder/widgets/square-photo-item.dart';

class SpotsListScreen extends StatefulWidget {
  static String route = '/spots-list';
  final String userId;

  SpotsListScreen({Key key, @required this.userId}) : super(key: key);

  @override
  _SpotsListScreenState createState() => _SpotsListScreenState();
}

class _SpotsListScreenState extends State<SpotsListScreen> {
  Future<ResultWrapper<List<Spot>>> _spots;

  @override
  void initState() {
    this._bindServices();
    super.initState();
  }

  void _bindServices() {
    this._spots = Repository().getUserSpots(
      new SearchWithPagination(widget.userId, 1, 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).userSpotsTitle),
        backgroundColor: Color(0xFF011627),
      ),
      body: FutureBuilder<ResultWrapper<List<Spot>>>(
        future: this._spots,
        builder: (BuildContext context,
            AsyncSnapshot<ResultWrapper<List<Spot>>> snapshot) {
          if (snapshot.hasData) {
            ResultWrapper<List<Spot>> wrapper = snapshot.data;
            List<Spot> spots = wrapper.result;

            return this._gridView(spots);
          } else if (snapshot.hasError) {
            return Retry(retryCalled: () => this._retrySpotsFetch());
          } else {
            return Container(child: Center(child: CircularProgressIndicator()));
          }
        },
      ),
    );
  }

  GridView _gridView(List<Spot> spots) {
    return GridView.builder(
      itemCount: spots.length,
      padding: EdgeInsets.only(top: 0),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  SpotDetailsScreen(spot: spots[index]),
            ),
          );
        },
        child: this._getItemView(spots[index]),
      ),
    );
  }

  GridTile _getItemView(Spot spot) {
    return GridTile(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent, width: 4.0),
        ),
        child: SquarePhotoItem(
          url: '${Constants.getBaseApi()}/picture/id/${spot.getThumbnail()}',
          size: 120.0,
        ),
      ),
    );
  }

  void _retrySpotsFetch() {
    setState(() {
      this._bindServices();
    });
  }
}
