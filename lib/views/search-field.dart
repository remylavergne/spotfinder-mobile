import 'package:flutter/material.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/models/spot.model.dart';
import 'package:spotfinder/repositories/repository.dart';

class Search extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        primaryColor: Color(0xFF011627),
        primaryTextTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
        secondaryHeaderColor: Colors.white);
  } // TODO: refaire couleur

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            this.query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    debugPrint(this.query);
    // Faire la recherche :)

    if (this.query.length <= 3) {
      return Container(
        child: Center(
          child: Text('Recherche trop courte'),
        ),
      );
    }

    return FutureBuilder(
      future: Repository().search(this.query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          ResultWrapper<List<Spot>> wrapper = snapshot.data;
          List<Spot> spots = wrapper.result;

          return GridView.builder(
            itemCount: spots.length,
            padding: EdgeInsets.only(top: 0),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: () {
                // Navigator.pushNamed(context, SpotDetailsScreen.route,
                //     arguments: spots[index]);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (BuildContext context) =>
                //             SpotDetailsScreen(spot: spots[index])));
              },
              child: this._getSpotWidget(spots[index]),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error...');
        } else {
          return Container(
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  GridTile _getSpotWidget(Spot spot) {
    return GridTile(
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 0.5)),
            child: Image.network(
                '${Constants.getBaseApi()}/picture/id/${spot.pictureId}',
                fit: BoxFit.cover)));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }
}
