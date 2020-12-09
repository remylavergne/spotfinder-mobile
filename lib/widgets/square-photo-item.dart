import 'package:flutter/widgets.dart';

class SquarePhotoItem extends StatelessWidget {
  final double size;
  final String url;

  SquarePhotoItem({Key key, @required this.url, @required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(6.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          url,
          height: size,
          width: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
