import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/customwiget/musicrow.dart';
import 'package:musicplayer/funtions/Audioplayer.dart';
import 'package:musicplayer/funtions/datastore.dart';

class Specificlistpage extends StatefulWidget {
  String imageUrl;
  String filter;

  Specificlistpage(this.imageUrl, this.filter);

  @override
  State<Specificlistpage> createState() => _Specificlistpage(imageUrl);
}

class _Specificlistpage extends State<Specificlistpage> {
  late final String artistName;
  List<DocumentSnapshot> tempdata = [];
  late SimpleAudioPlayer audioPlayer;
  late String imageUrl;
  late Datastore datastore;
  _Specificlistpage(this.imageUrl);
  void initState() {
    super.initState();
    List<DocumentSnapshot>? retrievedMusicList = Datastore().getMusicList();
    audioPlayer = SimpleAudioPlayer();
    datastore = Datastore();
    // Now, retrievedMusicList contains the music list
    // You can use the data as needed, for example, print the titles
    // if (retrievedMusicList != null) {
    //   for (var snapshot in retrievedMusicList) {
    //     print(snapshot[
    //         'musicname']); // Adjust the key based on your data structure
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "WALKMAN",
            style: TextStyle(
              color: Color(0xFF070707),
              fontFamily: "walkman",
              fontSize: 30,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 90, 5, 202),
          elevation: 0.0,
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 90, 5, 202),
        child: Column(children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              height: 100,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                color: Color.fromARGB(255, 90, 5, 202),
                child: Positioned.fill(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                  child: MusicListView(
                height: double.infinity,
                musicList: datastore.getMusicList(),
                audioplayer: audioPlayer,
                datastore: Datastore(),
                filterParameter: widget.filter,
              )))
        ]),
      ),
    );
  }
}
