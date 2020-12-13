import 'package:flutter/widgets.dart';

class NavigatorHelper {
  NavigatorHelper._privateConstructor();

  static final NavigatorHelper instance = NavigatorHelper._privateConstructor();

  void popTimes(int times, BuildContext context) {
    for (int i = 0; i <= times; i++) {
      Navigator.pop(context);
    }
  }
}
