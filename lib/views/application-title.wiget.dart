import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ApplicationTitle extends StatelessWidget {
  final String title;
  final double size;
  final Color backgroundColor;
  final Color foregroundColor;
  final String fontFamily;
  final double strokeSize;

  ApplicationTitle(
      {Key key,
      @required this.title,
      @required this.size,
      this.strokeSize,
      this.fontFamily,
      this.backgroundColor,
      this.foregroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Paint paint = Paint();
    paint.color =
        this.foregroundColor != null ? this.foregroundColor : Colors.white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = this.strokeSize != null ? this.strokeSize : 3.0;

    return Stack(children: [
      Text(
        this.title,
        style: TextStyle(
          foreground: paint,
          fontFamily: this.fontFamily != null ? this.fontFamily : 'NorthCoast',
          fontSize: this.size,
        ),
      ),
      Text(
        this.title,
        style: TextStyle(
          fontFamily: this.fontFamily != null ? this.fontFamily : 'NorthCoast',
          fontSize: this.size,
          color: this.backgroundColor != null
              ? this.backgroundColor
              : Color(0xFFFF7761),
        ),
      ),
    ]);
  }
}
