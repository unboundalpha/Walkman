import 'package:flutter/material.dart';
import 'package:musicplayer/customwiget/musicrow.dart';
import 'package:musicplayer/funtions/Audioplayer.dart';
import 'package:musicplayer/funtions/datastore.dart';

class Library extends StatefulWidget {
  final SimpleAudioPlayer audioPlayer;
  final Datastore datastore;

  Library({required this.audioPlayer, required this.datastore});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  late final SimpleAudioPlayer audioPlayer;
  late final Datastore datastore;

  @override
  void initState() {
    super.initState();
    audioPlayer = widget.audioPlayer;
    datastore = widget.datastore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Color(0xFF070707),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black,
              child: MusicListView(
                height: double.infinity,
                musicList: datastore.getMusicList(),
                audioplayer: audioPlayer,
                datastore: datastore,
                displayOnlyFavorites: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
