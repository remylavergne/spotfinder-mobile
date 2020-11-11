import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    this.tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            this._header(mediaQueryData, this.tabController),
            Container(
              child: TabBarView(
                controller: this.tabController,
                children: [Icon(Icons.ac_unit_sharp), Icon(Icons.search)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(MediaQueryData mediaQueryData, TabController tabController) {
    return Container(
      color: Color(0xFF011627),
      // height: 150.0,
      padding: EdgeInsets.only(top: mediaQueryData.padding.top),
      child: Column(
        children: [
          // Champs de recherche
          Container(
            margin: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
            ),
            child: Container(
              height: 35.0,
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    contentPadding: const EdgeInsets.all(8.0),
                    // isDense: true,
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(6.0),
                      ),
                    ),
                    filled: true,
                    fillColor: Color(0xFFD4D4D4),
                    hintText: 'Search'),
              ),
            ),
          ),
          // TabBar
          Container(
            margin: EdgeInsets.only(top: 16.0),
            child: TabBar(
              tabs: [Icon(Icons.search), Icon(Icons.bluetooth_searching)],
              controller: this.tabController,
            ),
          )
        ],
      ),
    );
  }

  Widget _body() {
    return Container();
  }
}
