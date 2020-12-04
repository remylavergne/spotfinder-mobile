import 'package:flutter/material.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/models/spot.model.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/screens/spot-details.screen.dart';

class Search extends SearchDelegate {
  ResultWrapper<List<Spot>> lastResults;
  String previousQuery = '';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        primaryIconTheme: IconThemeData(
          color: Colors.white,
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        primaryColor: Color(0xFF011627),
        primaryTextTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
        secondaryHeaderColor: Colors.white);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            this.query = '';
            this.lastResults = null;
            this.previousQuery = '';
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
    String currentQuery = this.query.trim();
    if (currentQuery.length == 0) {
      return Container(
        child: Center(
          child: Text('Veuillez taper une recherche'),
        ),
      );
    } else if (currentQuery.length <= 3) {
      return Container(
        child: Center(
          child: Text('Recherche trop courte'),
        ),
      );
    }

    return FutureBuilder(
      future: currentQuery == this.previousQuery && this.lastResults != null
          ? Future.value(this.lastResults)
          : Repository().search(currentQuery),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          ResultWrapper<List<Spot>> wrapper = snapshot.data;
          this.lastResults = wrapper;
          List<Spot> spots = wrapper.result;

          if (currentQuery != this.previousQuery) {
            this.previousQuery = currentQuery;
          }

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
                            SpotDetailsScreen(spot: spots[index])));
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
