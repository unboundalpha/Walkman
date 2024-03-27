import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/customwiget/musicrow.dart';
import 'package:musicplayer/funtions/Audioplayer.dart';
import 'package:musicplayer/funtions/Musiccontrols.dart';
import 'package:musicplayer/funtions/datastore.dart';
import 'package:musicplayer/screens/home.dart';
import 'package:musicplayer/screens/musicsearch.dart';
import 'package:musicplayer/screens/playlistpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicGrid extends StatefulWidget {
  @override
  State<MusicGrid> createState() => _MusicGridState();

  void setMusicControlsVisibility(bool bool) {}
}

class _MusicGridState extends State<MusicGrid> {
  int _currentIndex = 0;
  bool isPlaying = false;
  late SimpleAudioPlayer AudioPlayer;
  late Datastore datastore;
  late List<Widget> _pages;
  var musicControlVisibility = false;
  late final MusicListView musicListView;
  late MusicListView instaceoflistview;
  void updateMusicControlVisibility(bool isVisible) {
    setState(() {
      musicControlVisibility = isVisible;
      instaceoflistview = datastore.getMusicListViewInstance()!;
    });
  }

  @override
  void initState() {
    super.initState();

    AudioPlayer = SimpleAudioPlayer();
    datastore = Datastore();

    AudioPlayer.setOnPlayFromUrlCallback(() {
      updateMusicControlVisibility(true);
    });
    _pages = [
      Home(AudioPlayer, datastore),
      Find(audioPlayer: AudioPlayer, datastore: datastore),
      Library(audioPlayer: AudioPlayer, datastore: datastore),
      Settings(),
    ];
  }

  @override
  void dispose() {
    AudioPlayer.dispose();
    super.dispose();
  }

  List<List<Color>> gradientColors = [
    [Color(0xFF070707), Color(0xFF070707), Color(0xFF070707)],
    [Color(0xFF070707), Color(0xFF070707), Color(0xFF070707)],
    [Color(0xFF070707), Color(0xFF070707), Color(0xFF070707)],
    [Color(0xFF070707), Color(0xFF070707), Color(0xFF070707)],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.5, 1.0],
                colors: gradientColors[_currentIndex],
              ),
            ),
            child: _currentIndex == 3 ? Settings() : _pages[_currentIndex],
          ),
          if (_currentIndex != 3 && musicControlVisibility)
            Container(
              child: Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: MusicControls(
                  isPlaying: isPlaying,
                  onPlayPauseToggle: () {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                    if (AudioPlayer.isPlaying) {
                      AudioPlayer.pause();
                    } else {
                      AudioPlayer.resume();
                    }
                  },
                  onNextPressed: () {
                    // Handle next music logic
                    instaceoflistview.toggleplay(
                        datastore.getCurrentIndex() + 1, false);
                  },
                  onPreviousPressed: () {
                    // Handle previous music logic
                    instaceoflistview.toggleplay(
                        datastore.getCurrentIndex() - 1, false);
                  },
                  audioplayer: AudioPlayer,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightBlue,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Color(0xFF070707)),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Find',
              backgroundColor: Color(0xFF070707)),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
              backgroundColor: Color(0xFF070707)),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Color(0xFF070707)),
        ],
        selectedItemColor: Color.fromARGB(255, 90, 5, 202),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Text(
            'SETTINGS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            // Implement sign-out functionality here
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 90, 5, 202),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: TextButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('email', ""); // Set email to null
                    await prefs.setString(
                        'password', ''); // Set password to empty string
                    Navigator.pop(context);
                  },
                  child: Text("Sign out",
                      style: TextStyle(color: Colors.white, fontSize: 20))),
            ),
          ),
        ),
      ],
    );
  }
}
