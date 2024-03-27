import 'package:flutter/material.dart';
import 'package:musicplayer/funtions/Audioplayer.dart';
import 'package:musicplayer/funtions/datastore.dart';
import 'package:musicplayer/screens/musicplayingscreen.dart';

class MusicControls extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback onPlayPauseToggle;
  final VoidCallback onNextPressed;
  final VoidCallback onPreviousPressed;
  final SimpleAudioPlayer audioplayer;
  String musicname;
  String artistname;

  MusicControls({
    required this.isPlaying,
    required this.onPlayPauseToggle,
    required this.onNextPressed,
    required this.onPreviousPressed,
    required this.audioplayer,
    this.artistname = "",
    this.musicname = "",
  });

  @override
  State<MusicControls> createState() =>
      _MusicControlsState(artistname, musicname);
}

class _MusicControlsState extends State<MusicControls> {
  late Datastore datastore;
  String Artistname = "";
  String Musicname = '';

  _MusicControlsState(String artistname, String musicname) {
    Artistname = artistname;
    Musicname = musicname;
  }

  void initState() {
    super.initState();
    datastore = Datastore();
    Artistname = datastore.getCurrentArtist();
    Musicname = datastore.getCurrentSong();
  }

  void refreshData(String artist, String music) {
    setState(() {
      Artistname = artist;
      Musicname = music;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MusicPlayingScreen(
              songTitle: datastore.getCurrentSong(),
              artistName: datastore.getCurrentArtist(),
              albumName: datastore.getCurrentAlbum(),
              albumCover: datastore.getCurrentAlbumCover(),
              totalTime: widget.audioplayer.getTotalDuration().toString(),
              audioPlayer: widget.audioplayer,
              index: datastore.getCurrentIndex(),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
            colors: [
              Color(0xFF070707),
              Color.fromARGB(255, 90, 5, 202),
              Color(0xFF070707),
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Musicname,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    Artistname,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.skip_previous),
              onPressed: () {
                widget.onPreviousPressed();
                refreshData(
                    datastore.getCurrentArtist(), datastore.getCurrentSong());
              },
              color: Colors.white,
            ),
            StreamBuilder<bool>(
              stream: widget.audioplayer.isPlayingStream,
              builder: (context, snapshot) {
                bool isPlaying = snapshot.data ?? false;
                return IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    if (isPlaying) {
                      widget.audioplayer.pause();
                    } else {
                      widget.audioplayer.resume();
                    }
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.skip_next),
              onPressed: () {
                widget.onNextPressed();
                refreshData(
                    datastore.getCurrentArtist(), datastore.getCurrentSong());
              },
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
