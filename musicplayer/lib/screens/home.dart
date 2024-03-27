import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicplayer/customwiget/horizondalimageview.dart';
import 'package:musicplayer/customwiget/musicrow.dart';
import 'package:musicplayer/customwiget/textscroll.dart';
import 'package:musicplayer/funtions/Audioplayer.dart';
import 'package:musicplayer/funtions/datastore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final SimpleAudioPlayer audioplayer;
  final Datastore datastore;

  Home(this.audioplayer, this.datastore);

  @override
  State<Home> createState() => MyHome();
}

class MyHome extends State<Home> {
  late Future<List<DocumentSnapshot>> musicData;
  late Future<List<DocumentSnapshot>> artistData;
  late SimpleAudioPlayer audioplayer;
  late Datastore datastore;
  late SharedPreferences prefs;

  ScrollController _scrollController = ScrollController();
  GlobalKey _albumkey = GlobalKey();

  @override
  void initState() {
    super.initState();
    audioplayer = widget.audioplayer;
    datastore = widget.datastore;
    musicData = _fetchMusicData();
    artistData = _fetchArtistData();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();

    // Check if the favorites list exists
    if (!prefs.containsKey('favorites')) {
      // If not, create an empty list
      prefs.setString('favorites', jsonEncode([]));
    } else {
      // If exists, retrieve the favorites list and pass it to Datastore
      List<dynamic>? favorites =
          jsonDecode(prefs.getString('favorites')!) as List<dynamic>?;
      List<int> favoriteIds =
          favorites?.map<int>((fav) => fav as int).toList() ?? [];
      datastore.setSharedp(prefs);
      datastore.setFav(favoriteIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Container(
                color: Color(0xFF070707),
                child: Center(
                  child: Text(
                    "WALKMAN",
                    style: TextStyle(
                      color: Color.fromARGB(255, 90, 5, 202),
                      fontFamily: "walkman",
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              child: Stack(
                children: [
                  datastore.getArtistList() != null &&
                          datastore.getMusicList().isNotEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: RoundedContainer(
                              text1: "New Album",
                              text2: "",
                              text3: datastore.getMusicList().last['musicname']
                                  as String,
                              text4: datastore.getMusicList().last['artistname']
                                  as String,
                              imagePath: datastore.getArtistImageLink(
                                  datastore.getMusicList().last['artistname']),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            SidewaysScrollView(
              texts: ['Artists', 'New', 'Albums', 'Favourite'],
              onItemClicked: (position) {
                print('Item clicked at position: $position');
                if (position == 2) {
                  _scrollController.animateTo(
                    _albumkey.currentContext!
                        .findRenderObject()!
                        .paintBounds
                        .top,
                    duration: Duration(seconds: 1),
                    curve: Curves.easeInOut,
                  );
                }
                // Do something with the clicked position
              },
            ),
            SizedBox(height: 15),
            // Artist Horizontal Scroll View
            FutureBuilder(
              future: artistData,
              builder:
                  (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<DocumentSnapshot> artistList = snapshot.data!;
                  datastore.setArtistList(artistList);
                  return HorizontalImagesRoll(
                    images: artistList
                        .map((doc) => doc['imagelink'] as String)
                        .toList(),
                    itemCount: artistList.length,
                    containerHeight: 150,
                    containerWidth: 100,
                    heading: "Artists",
                    showPlayButton: true,
                    titles:
                        artistList.map((doc) => doc['name'] as String).toList(),
                    subtitles: List.filled(artistList.length, ''),
                  );
                }
              },
            ),
            // New Music Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "New",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'satoshi',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder(
              future: musicData,
              builder:
                  (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<DocumentSnapshot> musicList = snapshot.data!;
                  Datastore().setMusicList(musicList);
                  print("success");
                  return MusicListView(
                    height: 300,
                    musicList: musicList,
                    audioplayer: audioplayer,
                    datastore: datastore,
                  );
                }
              },
            ),
            FutureBuilder(
              key: _albumkey,
              future: musicData,
              builder:
                  (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<DocumentSnapshot> musiclist = snapshot.data!;
                  return HorizontalImagesRoll(
                    images: musiclist
                        .map((doc) => doc['albumcover'] as String)
                        .toList(),
                    itemCount: musiclist.length,
                    containerHeight: 150,
                    containerWidth: 100,
                    heading: "Albums",
                    showPlayButton: true,
                    titles:
                        musiclist.map((doc) => doc['album'] as String).toList(),
                    // subtitles: List.filled(musiclist.length, ''),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Favourite",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'satoshi',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder(
              future: musicData,
              builder:
                  (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<DocumentSnapshot> musicList = snapshot.data!;
                  Datastore().setMusicList(musicList);
                  print("success");
                  return MusicListView(
                      height: 300,
                      musicList: musicList,
                      audioplayer: audioplayer,
                      datastore: datastore,
                      displayOnlyFavorites: true);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHorizontalListView(String heading, int itemCount,
      double containerWidth, double containerHeight) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              heading,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                double randomWidth =
                    Random().nextInt(50).toDouble() + containerWidth;
                double randomHeight =
                    Random().nextInt(50).toDouble() + containerHeight;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: randomWidth,
                    height: randomHeight,
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color(0xff515151),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                      child: Text(
                        'Item $index',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<DocumentSnapshot>> _fetchArtistData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Artistid').get();

    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> _fetchMusicData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('MusicData').get();

    return querySnapshot.docs;
  }
}

class RoundedContainer extends StatelessWidget {
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  final String? imagePath;

  RoundedContainer({
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            color: Colors.black12,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 90, 5, 202),
                  borderRadius: BorderRadius.circular(
                      15.0), // Adjust the radius as needed
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text1,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Satoshi', fontSize: 10),
                ),
                SizedBox(height: 8.0),
                Expanded(
                  child: Text(
                    text3,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Satoshi',
                        fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Text(
                    text4,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Satoshi',
                        fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (imagePath != null)
          Positioned(
            bottom: 8.0, // Adjust the bottom position as needed
            right: 8.0, // Adjust the right position as needed
            child: Image.network(
              imagePath!,
              width: 110.0, // Adjust the width as needed
              height: 110.0,
              fit: BoxFit.fitHeight,
            ),
          ),
      ],
    );
  }
}
