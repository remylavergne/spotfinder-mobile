import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:spotfinder/models/spot.model.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/views/spot-details.dart';

class SpotList extends StatefulWidget {
  SpotList({Key key}) : super(key: key);

  @override
  _SpotListState createState() => _SpotListState();
}

class _SpotListState extends State<SpotList> {
  final PagingController<int, Spot> _pagingController =
      PagingController(firstPageKey: 0);

  Future<List<Widget>> items;

  @override
  void initState() {
    this.items = Repository()
        .getSpots()
        .then((List<Spot> spots) => this._getItems(spots));
    // final response = Repository().getPaginatedSpots(0, 20);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        padding: EdgeInsets.only(top: SpotListConstante.listAdditonalTopPAdding,
        child: this._spotList(),
      ),
    );
  }

  Widget _spotList() {
    return FutureBuilder(
        future: this.items,
        builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
          if (snapshot.hasData) {
            final items = snapshot.data;
            return Expanded(
              child: Container(
                child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(SpotListConstante.listGlobalPadding),
                    crossAxisSpacing: SpotListConstante.crossAxisSpacing,
                    mainAxisSpacing: SpotListConstante.mainAxisSpacing,
                    crossAxisCount: 2,
                    children: items),
              ),
            );
          } else {
            return Container(
              color: Colors.green,
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  /// Generate the whole items list
  Future<List<Widget>> _getItems(List<Spot> spots) {
    List<Widget> items = [];

    spots.forEach((Spot spot) {
      final item = this._generateSpotItem(spot);
      items.add(item);
    });

    return Future.value(items);
  }

  Widget _generateSpotItem(Spot spot) {
    return GestureDetector(
      onTap: () {
        debugPrint('Spot clicked');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SpotDetails()),
        );
      },
      child: Card(
        child: Container(
          child: Image.network(
            'https://www.wampark.fr/wp-content/uploads/2020/03/wakeskate8x15.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class SpotListConstante {
  static const double listGlobalPadding = 2.0;
  static const double listAdditonalTopPAdding = 2.0;
  static const double crossAxisSpacing = 2.0;
  static const double mainAxisSpacing = 2.0;
}
