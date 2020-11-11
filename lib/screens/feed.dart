import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotfinder/camera.helper.dart';
import 'package:spotfinder/views/take-picture.dart';

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
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background view
            Container(
              child: Column(
                children: [
                  this._header(mediaQueryData, this.tabController),
                  Expanded(
                    child: TabBarView(
                      controller: this.tabController,
                      children: [this._gridCloseSpotMOCK(), Icon(Icons.search)],
                    ),
                  ),
                ],
              ),
            ),
            // Button to create
            Container(
              alignment: Alignment.bottomCenter,
              width: 180.0,
              margin: EdgeInsets.only(bottom: mediaQueryData.padding.bottom),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                color: Color(0xFF148F12),
                textColor: Colors.white,
                height: 56.0,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TakePictureScreen(
                              camera: CameraService.instance.getCamera())));
                },
                child: Text(
                  'Créer',
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                ),
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
            // padding: EdgeInsets.only(bottom: 10.0),
            child: TabBar(
              indicatorColor: Color(0xFFD4D4D4),
              labelPadding: EdgeInsets.only(bottom: 10.0),
              tabs: [Text('Proches'), Text('Nouveaux')],
              controller: this.tabController,
            ),
          )
        ],
      ),
    );
  }

  Widget _gridCloseSpotMOCK() {
    return GridView.count(
      padding: EdgeInsets.only(top: 0),
      crossAxisCount: 3,
    children: [
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://www.skatereview.com/wp-content/uploads/2017/07/skateboard-trick-tipp-nollie-heelflip.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.pinimg.com/originals/f2/26/15/f22615c8787e5e99406c22c791d62d32.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://www.activethrills.com/wp-content/uploads/2017/09/skateboard-tricks-780x400.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.ytimg.com/vi/gSEvU9drzfw/maxresdefault.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.ytimg.com/vi/9hySkXBQJTM/hqdefault.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.pinimg.com/originals/c5/2b/5b/c52b5b980bbfe3e79993823bb93149f7.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://c0.wallpaperflare.com/preview/67/584/1008/man-skate-board-trick.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://www.skatereview.com/wp-content/uploads/2017/07/skateboard-trick-tipp-nollie-heelflip.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.pinimg.com/originals/f2/26/15/f22615c8787e5e99406c22c791d62d32.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://www.activethrills.com/wp-content/uploads/2017/09/skateboard-tricks-780x400.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.ytimg.com/vi/gSEvU9drzfw/maxresdefault.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.ytimg.com/vi/9hySkXBQJTM/hqdefault.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.pinimg.com/originals/c5/2b/5b/c52b5b980bbfe3e79993823bb93149f7.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://c0.wallpaperflare.com/preview/67/584/1008/man-skate-board-trick.jpg', fit: BoxFit.cover))),
          GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://www.skatereview.com/wp-content/uploads/2017/07/skateboard-trick-tipp-nollie-heelflip.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.pinimg.com/originals/f2/26/15/f22615c8787e5e99406c22c791d62d32.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://www.activethrills.com/wp-content/uploads/2017/09/skateboard-tricks-780x400.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.ytimg.com/vi/gSEvU9drzfw/maxresdefault.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.ytimg.com/vi/9hySkXBQJTM/hqdefault.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.pinimg.com/originals/c5/2b/5b/c52b5b980bbfe3e79993823bb93149f7.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://c0.wallpaperflare.com/preview/67/584/1008/man-skate-board-trick.jpg', fit: BoxFit.cover))),
          GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://www.skatereview.com/wp-content/uploads/2017/07/skateboard-trick-tipp-nollie-heelflip.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.pinimg.com/originals/f2/26/15/f22615c8787e5e99406c22c791d62d32.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://www.activethrills.com/wp-content/uploads/2017/09/skateboard-tricks-780x400.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.ytimg.com/vi/gSEvU9drzfw/maxresdefault.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.ytimg.com/vi/9hySkXBQJTM/hqdefault.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.pinimg.com/originals/c5/2b/5b/c52b5b980bbfe3e79993823bb93149f7.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://c0.wallpaperflare.com/preview/67/584/1008/man-skate-board-trick.jpg', fit: BoxFit.cover))),
          GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://www.skatereview.com/wp-content/uploads/2017/07/skateboard-trick-tipp-nollie-heelflip.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.pinimg.com/originals/f2/26/15/f22615c8787e5e99406c22c791d62d32.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://www.activethrills.com/wp-content/uploads/2017/09/skateboard-tricks-780x400.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.ytimg.com/vi/gSEvU9drzfw/maxresdefault.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.ytimg.com/vi/9hySkXBQJTM/hqdefault.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.pinimg.com/originals/c5/2b/5b/c52b5b980bbfe3e79993823bb93149f7.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://c0.wallpaperflare.com/preview/67/584/1008/man-skate-board-trick.jpg', fit: BoxFit.cover))),
          GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://www.skatereview.com/wp-content/uploads/2017/07/skateboard-trick-tipp-nollie-heelflip.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.pinimg.com/originals/f2/26/15/f22615c8787e5e99406c22c791d62d32.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://www.activethrills.com/wp-content/uploads/2017/09/skateboard-tricks-780x400.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.ytimg.com/vi/gSEvU9drzfw/maxresdefault.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.ytimg.com/vi/9hySkXBQJTM/hqdefault.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.pinimg.com/originals/c5/2b/5b/c52b5b980bbfe3e79993823bb93149f7.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://c0.wallpaperflare.com/preview/67/584/1008/man-skate-board-trick.jpg', fit: BoxFit.cover))),
          GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://www.skatereview.com/wp-content/uploads/2017/07/skateboard-trick-tipp-nollie-heelflip.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.pinimg.com/originals/f2/26/15/f22615c8787e5e99406c22c791d62d32.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://www.activethrills.com/wp-content/uploads/2017/09/skateboard-tricks-780x400.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.ytimg.com/vi/gSEvU9drzfw/maxresdefault.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.ytimg.com/vi/9hySkXBQJTM/hqdefault.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.pinimg.com/originals/c5/2b/5b/c52b5b980bbfe3e79993823bb93149f7.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://c0.wallpaperflare.com/preview/67/584/1008/man-skate-board-trick.jpg', fit: BoxFit.cover))),
          GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://www.skatereview.com/wp-content/uploads/2017/07/skateboard-trick-tipp-nollie-heelflip.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.pinimg.com/originals/f2/26/15/f22615c8787e5e99406c22c791d62d32.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://www.activethrills.com/wp-content/uploads/2017/09/skateboard-tricks-780x400.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.ytimg.com/vi/gSEvU9drzfw/maxresdefault.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.ytimg.com/vi/9hySkXBQJTM/hqdefault.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://i.pinimg.com/originals/c5/2b/5b/c52b5b980bbfe3e79993823bb93149f7.jpg', fit: BoxFit.cover))),
      GridTile(
        child: Container(
          decoration:
      BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Image.network('https://c0.wallpaperflare.com/preview/67/584/1008/man-skate-board-trick.jpg', fit: BoxFit.cover))),
    ],);
  }
}
