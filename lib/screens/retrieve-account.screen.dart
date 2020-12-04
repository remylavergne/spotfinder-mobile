import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  bool creationError = false;
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          this._viewPager(),
          Container(
              margin: EdgeInsets.only(top: 35.0),
              alignment: Alignment.topCenter,
              child: ApplicationTitle(title: 'SpotFinder', size: 130.0)),
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
                      hintText: 'Username',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your id';
                      } else if (creationError) {
                        creationError = false;
                        return 'Please check your username / password';
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
                      hintText: 'Password',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your password';
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
                            'Retour',
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
                              bool success = await Repository().connectUserByCredentials(
                                  this.usernameCtrl.text.trim(),
                                  this.passwordCtrl.text.trim());
                              if (success) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FeedScreen()));
                              } else {
                                creationError = true;
                                _formKey.currentState.validate();
                              }
                            }
                          },
                          child: Text(
                            'Continuer',
                            style: TextStyle(
                                fontSize: 26.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ])),
    );
  }
}
