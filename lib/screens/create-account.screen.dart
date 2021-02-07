import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/generated/l10n.dart';
import 'package:spotfinder/helpers/throttling.dart';
import 'package:spotfinder/models/dto/login-infos.dto.dart';
import 'package:spotfinder/repositories/repository.dart';
import 'package:spotfinder/screens/display-clear-password.screen.dart';
import 'package:spotfinder/screens/retrieve-account.screen.dart';
import 'package:spotfinder/widgets/application-title.dart';
import 'package:spotfinder/widgets/fullscreen-loader.dart';

class CreateAccountScreen extends StatefulWidget {
  static String route = '/create-account';

  CreateAccountScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccountScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  Throttling _createSpotThrottling = Throttling(Duration(seconds: 5));
  bool _creationError = false;
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
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Color(0xFF989898),
                    fontSize: 18.0,
                  ),
                  hintText: S.of(context).chooseYourUsername,
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return S.of(context).pleaseEnterUsername;
                  } else if (this._creationError) {
                    this._creationError = false;
                    return S.of(context).usernameAlreadyExists;
                  } else if (value.contains(' ')) {
                    return S.of(context).usernameSpaceNotAllowed;
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
                    this._loaderState();
                    this._createSpotThrottling.throttle(() => this
                        ._createAccountProcess(
                            _usernameController.text, context));
                  }
                },
                child: Text(
                  S.of(context).next,
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
                    MaterialPageRoute(
                        builder: (context) => RetrieveAccountScreen()),
                  );
                },
                child: Text(
                  S.of(context).login,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createAccountProcess(String username, BuildContext context) async {
    LoginInfos infos = await Repository().createAccount(username.trim());
    this._loaderState();
    if (infos != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ClearPasswordScreen(clearPassword: infos.password),
        ),
      );
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
