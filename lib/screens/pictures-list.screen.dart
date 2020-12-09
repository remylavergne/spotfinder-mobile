import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/constants.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/models/comment.model.dart';
import 'package:spotfinder/models/dto/search-with-pagination.dto.dart';
import 'package:spotfinder/models/picture.model.dart';
import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/screens/picture-full.screen.dart';

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
        this._pictures = Repository()
            .getUserPictures(new SearchWithPagination(widget.id, 1, 40));
        break;
      default:
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.photosTitle),
        backgroundColor: Color(0xFF011627),
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
            return Center(
                child: Text(S.current.errorAndRetry)); // TODO: Retry button
          } else {
            return Container(child: Center(child: CircularProgressIndicator()));
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  PictureFullScreen(picture: pictures[index]),
            ),
          );
        },
        child: this._getItemView(pictures[index]),
      ),
    );
  }

  GridTile _getItemView(Picture picture) {
    return GridTile(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0.5),
        ),
        child: Image.network(
            '${Constants.getBaseApi()}/picture/id/${picture.getThumbnail()}',
            fit: BoxFit.cover),
      ),
    );
  }
}
