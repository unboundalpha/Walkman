import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicplayer/customwiget/musicrow.dart';
import 'package:musicplayer/funtions/Audioplayer.dart';
import 'package:musicplayer/funtions/datastore.dart';

class Find extends StatefulWidget {
  final SimpleAudioPlayer audioPlayer;
  final Datastore datastore;

  Find({required this.audioPlayer, required this.datastore});

  @override
  _FindState createState() =>
      _FindState(audioPlayer: audioPlayer, datastore: datastore);
}

class _FindState extends State<Find> {
  final SimpleAudioPlayer audioPlayer;
  final Datastore datastore;
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  _FindState({required this.audioPlayer, required this.datastore});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _updateSearch("");
                      },
                    ),
                  ),
                  onChanged: (value) {
                    _updateSearch(value);
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
              child: Expanded(
                  flex: 1,
                  child: Container(
                      child: MusicListView(
                    height: double.infinity,
                    musicList: datastore.getMusicList(),
                    audioplayer: audioPlayer,
                    datastore: Datastore(),
                    filterParameter: _searchText,
                  )))),
        ),
      ],
    );
  }

  Future<List<DocumentSnapshot>> _fetchData() async {
    QuerySnapshot querySnapshot;

    if (_searchText.isEmpty) {
      querySnapshot = await _firestore.collection('MusicData').get();
    } else {
      querySnapshot = await _firestore
          .collection('MusicData')
          .where('searchKeywords', arrayContains: _searchText.toLowerCase())
          .get();
    }

    return querySnapshot.docs;
  }

  void _updateSearch(String searchText) {
    setState(() {
      _searchText = searchText;
    });
  }
}
