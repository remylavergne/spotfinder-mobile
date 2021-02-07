import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/helpers/throttling.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/screens/feed.screen.dart';
import 'package:spotfinder/widgets/application-title.dart';
import 'package:spotfinder/widgets/fullscreen-loader.dart';

class RetrieveAccountScreen extends StatefulWidget {
  static String route = '/retrieve-account';
  RetrieveAccountScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RetrieveAccount();
}

class _RetrieveAccount extends State<RetrieveAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  Throttling _loginThrottle = Throttling(Duration(seconds: 5));
  bool _creationError = false;
  TextEditingController _usernameCtrl = TextEditingController();
  TextEditingController _passwordCtrl = TextEditingController();
  bool _displayLoader = false;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: Image(
                image: AssetImage('assets/onboarding/onboarding-1.jpg'),
                fit: BoxFit.cover),
          ),
          Container(
            margin: EdgeInsets.only(top: 40.0),
            alignment: Alignment.topCenter,
            child: ApplicationTitle(
                title: S.of(context).appTitle,
                size: mediaQueryData.size.width * 0.25),
          ),
          Positioned.fill(child: this._form(context)),
          Visibility(visible: this._displayLoader, child: FullscreenLoader()),
        ],
      ),
    );
  }

  Widget _form(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
      child: Form(
        key: this._formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // Username
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                controller: this._usernameCtrl,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Color(0xFF989898),
                    fontSize: 18.0,
                  ),
                  hintText: S.current.usernameHint,
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return S.current.pleaseEnterUsername;
                  } else if (this._creationError) {
                    this._creationError = false;
                    return S.current.loginError;
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                controller: this._passwordCtrl,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Color(0xFF989898),
                    fontSize: 18.0,
                  ),
                  hintText: S.current.passwordHint,
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return S.current.passwordError;
                  } else {
                    return null;
                  }
                },
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 55.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 180.0,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      color: Color(0xFF011627),
                      textColor: Colors.white,
                      height: 56.0,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        S.current.back,
                        style: TextStyle(
                            fontSize: 26.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    width: 180.0,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      color: Color(0xFF276FBF),
                      textColor: Colors.white,
                      height: 56.0,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          this._loginThrottle.throttle(
                                () => this._loginUserProcess(
                                    context,
                                    this._usernameCtrl.text,
                                    this._passwordCtrl.text),
                              );
                        }
                      },
                      child: Text(
                        S.current.next,
                        style: TextStyle(
                            fontSize: 26.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loginUserProcess(
      BuildContext context, String username, String password) async {
    bool success = await Repository()
        .connectUserByCredentials(username.trim(), password.trim());
    if (success) {
      Navigator.pushNamedAndRemoveUntil(
          context, FeedScreen.route, (route) => false);
    } else {
      this._creationError = true;
      _formKey.currentState.validate();
    }
  }

  void _loaderState() {
    setState(() {
      this._displayLoader = !this._displayLoader;
    });
  }
}
