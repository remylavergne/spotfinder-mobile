import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RetrieveAccount extends StatelessWidget {
  RetrieveAccount({Key key}) : super(key: key);

  final controller = PageController(initialPage: 0);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          this._viewPager(),
          this._appName(),
          Positioned.fill(child: this._form(context)),
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
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Color(0xFF989898),
                        fontSize: 18.0,
                      ),
                      hintText: 'Entre ton id',
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
                      }
                      return null;
                    },
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
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              // TODO: Check backend + redirect

                              //             Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => RetrieveAccount()),
                              // );
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
