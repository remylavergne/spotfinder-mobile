import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/screens/feed.screen.dart';
import 'package:spotfinder/widgets/application-title.dart';
import 'package:spotfinder/widgets/bottom-action-button.dart';

class ClearPasswordScreen extends StatefulWidget {
  static String route = '/display-clear-password';

  final String clearPassword;

  ClearPasswordScreen({Key key, @required this.clearPassword})
      : super(key: key);

  @override
  _ClearPasswordScreenState createState() => _ClearPasswordScreenState();
}

class _ClearPasswordScreenState extends State<ClearPasswordScreen> {
  bool copied = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFE5E5E5),
        child: Stack(children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: ApplicationTitle(
                  title: S.of(context).appTitle,
                  size: 100.0,
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      S.current.accountCreatedTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: Text(
                        S.current.clearPasswordExplanation,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                    new ClipboardData(text: this.widget.clearPassword),
                  );
                  setState(() {
                    this.copied = true;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        this.widget.clearPassword,
                        style: TextStyle(
                            fontSize: 32.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Visibility(
                        visible: !this.copied,
                        child: Text(
                          S.current.clickToCopy,
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ),
                      Visibility(
                        visible: this.copied,
                        child: Text(
                          S.current.copy,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // TODO => bloquer back button
          BottomActionButton(
            parentContext: context,
            text: S.of(context).next,
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, FeedScreen.route, (route) => false);
            },
          ),
        ]),
      ),
    );
  }
}
