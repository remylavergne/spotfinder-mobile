import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreateAccount extends StatelessWidget {
  CreateAccount({Key key}) : super(key: key);

  final controller = PageController(initialPage: 0);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          this._viewPager(),
          this._appName(),
          Positioned.fill(child: this._form()),
        ],
      ),
    );
  }

  Widget _appName() {
    Paint paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;

    return Container(
      margin: EdgeInsets.only(top: 35.0),
      alignment: Alignment.topCenter,
      child: Stack(children: [
        Text(
          'SpotFinder',
          style: TextStyle(
            foreground: paint,
            fontFamily: 'NorthCoast',
            fontSize: 130.0,
          ),
        ),
        Text(
          'SpotFinder',
          style: TextStyle(
            fontFamily: 'NorthCoast',
            fontSize: 130.0,
            color: Color(0xFFFF7761),
          ),
        ),
      ]),
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
        Container(
          child: Image(
              image: AssetImage('assets/onboarding/onboarding-2.jpg'),
              fit: BoxFit.cover),
        ),
        Container(
          child: Image(
              image: AssetImage('assets/onboarding/onboarding-3.jpg'),
              fit: BoxFit.cover),
        ),
        Container(
          child: Image(
              image: AssetImage('assets/onboarding/onboarding-4.jpg'),
              fit: BoxFit.cover),
        ),
      ],
    );
  }

  Widget _form() {
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
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Color(0xFF989898),
                        fontSize: 18.0,
                      ),
                      hintText: 'Entre ton pseudo',
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
                      }
                      return null;
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
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        // TODO: Redirection vers la home
                      }
                    },
                    child: Text(
                      'Continuer',
                      style: TextStyle(
                          fontSize: 26.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: FlatButton(
                    onPressed: () {},
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
