import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicplayer/customwiget/musicrow.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Datastore {
  bool _isPlaying = false;
  String _currentSong = '';
  String _currentArtist = '';
  String _currentAlbum = '';
  String _currentAlbumCover = '';
  int _currentindex = -1;
  MusicListView? _musicListViewInstance;
  List<DocumentSnapshot>? artistList;
  List<DocumentSnapshot> musiclist = [];
  List<int> fav = [];
  late SharedPreferences pref;
  // Private constructor to prevent multiple instances
  Datastore._privateConstructor();

  // Singleton instance
  static final Datastore _instance = Datastore._privateConstructor();

  // Factory method to get the instance
  factory Datastore() {
    return _instance;
  }

  void setPlayingState(bool state) {
    _isPlaying = state;
  }

  bool returnPlayingState() {
    return _isPlaying;
  }

  void setCurrentSongDetails(
      String song, String artist, String album, String albumcover, int index) {
    _currentSong = song;
    _currentArtist = artist;
    _currentAlbum = album;
    _currentAlbumCover = albumcover;
    _currentindex = index;
  }

  String getCurrentSong() {
    return _currentSong;
  }

  String getCurrentArtist() {
    return _currentArtist;
  }

  String getCurrentAlbum() {
    return _currentAlbum;
  }

  String getCurrentAlbumCover() {
    return _currentAlbumCover;
  }

  int getCurrentIndex() {
    return _currentindex;
  }

  void setMusicListViewInstance(MusicListView musicListView) {
    _musicListViewInstance = musicListView;
  }

  MusicListView? getMusicListViewInstance() {
    return _musicListViewInstance;
  }

  void setMusicList(List<DocumentSnapshot> musicList) {
    this.musiclist = musicList;
  }

  // Getter for musicList
  List<DocumentSnapshot> getMusicList() {
    return musiclist;
  }

  // Setter for artistList
  void setArtistList(List<DocumentSnapshot> artistList) {
    this.artistList = artistList;
  }

  // Getter for artistList
  List<DocumentSnapshot>? getArtistList() {
    return artistList;
  }

  void setSharedp(SharedPreferences prefs) {
    pref = prefs;
  }

  void setFav(List<int> Fav) {
    fav = Fav;
    print("Favorates:${fav}");
    // Convert the favorites list to JSON string
    String favJson = jsonEncode(Fav);
    // Save the JSON string to SharedPreferences
    pref.setString('favorites', favJson);
  }

  void addtofav(int content) {
    fav.add(content);
    setFav(fav);
  }

  void removefromfav(int content) {
    fav.remove(content);
    setFav(fav);
  }

  List<int> getFav() {
    return fav;
  }

  getArtistImageLink(last) {
    if (artistList != null) {
      for (var artistData in artistList!) {
        if (artistData['name'] == last) {
          return artistData['imagelink'] as String;
        }
      }
    }
    return '';
  }
}
