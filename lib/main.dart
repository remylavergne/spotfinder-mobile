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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> spots = List();

  @override
  void initState() {
    this.spots.add(this._spot());
    this.spots.add(this._spot());
    this.spots.add(this._spot());
    this.spots.add(this._spot());
    this.spots.add(this._spot());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 56.0, left: 16.0, right: 16.0),
        child: Column(
          children: [
            this._header(),
            this._spotList(),
          ],
        ),
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
    if (this.spots.isNotEmpty) {
      return Expanded(
        child: Container(
          // color: Colors.green,
          child: ListView.builder(
              // shrinkWrap: true,
              itemCount: this.spots.length,
              itemBuilder: (BuildContext context, int index) {
                return this.spots[index];
              }),
        ),
      );
    } else {
      return Expanded(
        child: Container(
          color: Colors.green,
          child: Center(
            child: Text('Nothing to show...'),
          ),
        ),
      );
    }
  }

  Widget _spot() {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: NetworkImage(
              'https://www.wampark.fr/wp-content/uploads/2020/03/wakeskate8x15.jpg',
            ),
            fit: BoxFit.fill,
          ),
        ),
        height: 200.0,
        child: Text('Random texte'),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }
}
