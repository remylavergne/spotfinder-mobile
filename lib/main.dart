import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> widgets = new List();

  @override
  void initState() {
    this.widgets.add(this._header());
    this.widgets.add(Text('Coucou'));
    this.widgets.add(Text('Coucou'));
    this.widgets.add(Text('Coucou'));
    this.widgets.add(Text('Coucou'));

    print('Taille de la liste => ${this.widgets.length}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
        child: this._spotList(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Spotfinder',
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        _searchButton()
      ],
    );
  }

  Widget _searchButton() {
    return Container(
      height: 40.0,
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          shape: BoxShape.rectangle,
          color: Colors.grey),
      child: Center(
        child: Text("search"),
      ),
    );
  }

  Widget _spotList() {
    return ListView.builder(
        itemCount: this.widgets.length,
        itemBuilder: (BuildContext context, int index) {
          return this.widgets[index];
        });
  }
}
