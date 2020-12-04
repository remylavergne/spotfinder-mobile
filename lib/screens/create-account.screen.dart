import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/models/dto/login-infos.dto.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/screens/feed.screen.dart';
import 'package:spotfinder/screens/retrieve-account.screen.dart';
import 'package:spotfinder/widgets/application-title.dart';

class CreateAccountScreen extends StatefulWidget {
  static String route = '/create-account';

  CreateAccountScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccountScreen> {
  final controller = PageController(initialPage: 0);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          this._viewPager(),
          Container(
            // color: Colors.red,
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
              image: AssetImage('assets/onboarding/onboarding-2.jpg'),
              fit: BoxFit.cover),
        ),
        // Container(
        //   child: Image(
        //       image: AssetImage('assets/onboarding/onboarding-1.jpg'),
        //       fit: BoxFit.cover),
        // ),
        // Container(
        //   child: Image(
        //       image: AssetImage('assets/onboarding/onboarding-2.jpg'),
        //       fit: BoxFit.cover),
        // ),
        // Container(
        //   child: Image(
        //       image: AssetImage('assets/onboarding/onboarding-3.jpg'),
        //       fit: BoxFit.cover),
        // ),
        // Container(
        //   child: Image(
        //       image: AssetImage('assets/onboarding/onboarding-4.jpg'),
        //       fit: BoxFit.cover),
        // ),
      ],
    );
  }

  Widget _form(BuildContext context) {
    final usernameController = TextEditingController();
    bool creationError = false;
    return Container(
      margin: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
      child: Form(
          key: this._formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: <
              Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Color(0xFF989898),
                    fontSize: 18.0,
                  ),
                  hintText: 'Choisis ton pseudo',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your username';
                  } else if (creationError) {
                    creationError = false;
                    return 'This username already exist. Please choose another one.';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              width: double.infinity,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                color: Color(0xFF276FBF),
                textColor: Colors.white,
                height: 56.0,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    LoginInfos infos = await Repository()
                        .createAccount(usernameController.text.trim());
                    if (infos != null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FeedScreen())); // TODO: Change screen to show up password
                    } else {
                      creationError = true;
                      _formKey.currentState.validate();
                    }
                  }
                },
                child: Text(
                  'Continuer',
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RetrieveAccountScreen()),
                  );
                },
                child: Text(
                  'J\'ai déjà un ID',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ])),
    );
  }
}
