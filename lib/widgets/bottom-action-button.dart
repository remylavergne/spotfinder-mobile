import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomActionButton extends StatelessWidget {
  final BuildContext parentContext;
  final String text;
  final VoidCallback onTap;

  BottomActionButton({
    Key key,
    @required this.parentContext,
    @required this.text,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(parentContext);

    return Container(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: double.maxFinite,
        child: FlatButton(
          color: Color(0xFF011627),
          textColor: Colors.white,
          height: 56.0 + mediaQueryData.padding.bottom,
          onPressed: () {
            this.onTap();
          },
          child: Text(
            this.text,
            style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
