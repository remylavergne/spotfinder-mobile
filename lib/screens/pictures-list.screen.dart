import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/models/picture.model.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/repositories/repository.dart';

enum PicturesFrom { SPOT, USER }

class PicturesDisplayScreen extends StatefulWidget {
  static String route = '/pictures-list';
  final String id;
  final PicturesFrom type;

  PicturesDisplayScreen({Key key, @required this.id, @required this.type})
      : super(key: key);

  @override
  _PicturesDisplayScreenState createState() => _PicturesDisplayScreenState();
}

class _PicturesDisplayScreenState extends State<PicturesDisplayScreen> {
  Future<ResultWrapper<List<Picture>>> _pictures;

  @override
  void initState() {
    switch (widget.type) {
      case PicturesFrom.SPOT:
        this._pictures =
            Repository().getPaginatedSpotPictures(1, 20, widget.id);
        break;
      case PicturesFrom.USER:
        // TODO:
        break;
      default:
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos'),
      ),
      body: FutureBuilder<ResultWrapper<List<Picture>>>(
        future: this._pictures,
        builder: (BuildContext context,
            AsyncSnapshot<ResultWrapper<List<Picture>>> snapshot) {
          if (snapshot.hasData) {
            ResultWrapper<List<Picture>> wrapper = snapshot.data;
            List<Picture> pictures = wrapper.result;

            return this._gridView(pictures);
          } else if (snapshot.hasError) {
            return Text('ERROR...');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  GridView _gridView(List<Picture> pictures) {
    return GridView.builder(
      itemCount: pictures.length,
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
        child: this._getItemView(pictures[index]),
      ),
    );
  }

  GridTile _getItemView(Picture picture) {
    return GridTile(
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5)),
            child: Image.network(
                '${Constants.getBaseApi()}/picture/id/${picture.id}',
                fit: BoxFit.cover)));
  }
}
