import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/helpers/shared-preferences.helper.dart';

class UserProfileSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'), // TODO: Translate
        backgroundColor: Color(0xFF011627),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // TODO: Translate
            FlatButton(
                onPressed: () {
                  // TODO
                },
                child: Text('Add profile picture')),
            FlatButton(
              onPressed: () {
                // TODO
                SharedPrefsHelper.instance.logout();
              },
              child: Text(
                'Disconnect',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
