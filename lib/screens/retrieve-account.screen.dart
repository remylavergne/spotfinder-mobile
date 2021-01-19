import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/helpers/throttling.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/screens/feed.screen.dart';
import 'package:spotfinder/widgets/application-title.dart';

class RetrieveAccountScreen extends StatefulWidget {
  static String route = '/retrieve-account';
  RetrieveAccountScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RetrieveAccount();
}

class _RetrieveAccount extends State<RetrieveAccountScreen> {
  PageController controller = PageController(initialPage: 0);
  final _formKey = GlobalKey<FormState>();
  Throttling loginThrottle = Throttling(Duration(seconds: 5));
  bool creationError = false;
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      body: Stack(
        children: [
          this._viewPager(),
          Container(
            margin: EdgeInsets.only(top: 35.0),
            alignment: Alignment.topCenter,
            child: ApplicationTitle(title: S.of(context).appTitle, size: mediaQueryData.size.width * 0.3),
          ),
          Positioned.fill(child: this._form(context)),
        ],
      ),
    );
  }

  Widget _viewPager() {
    return PageView(
      controller: this.controller,
      children: [
        Container(
          child: Image(
              image: AssetImage('assets/onboarding/onboarding-1.jpg'),
              fit: BoxFit.cover),
        ),
      ],
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
                controller: this.usernameCtrl,
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
                  } else if (this.creationError) {
                    this.creationError = false;
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
                controller: this.passwordCtrl,
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
                          this.loginThrottle.throttle(
                                () => this._loginUserProcess(
                                    context,
                                    this.usernameCtrl.text,
                                    this.passwordCtrl.text),
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
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => FeedScreen(),
      //   ),
      // );
    } else {
      this.creationError = true;
      _formKey.currentState.validate();
    }
  }
}
