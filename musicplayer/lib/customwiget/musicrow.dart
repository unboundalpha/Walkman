import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicplayer/funtions/datastore.dart';
import 'package:musicplayer/screens/musicplayingscreen.dart';
import '../funtions/Audioplayer.dart';
import '../funtions/firebasefuntions.dart';

int playingindex = -1;
List<int> fav = [];

class MusicListView extends StatefulWidget {
  final double height;
  final List<DocumentSnapshot> musicList;
  final SimpleAudioPlayer audioplayer;
  final Datastore datastore;
  final String? filterParameter; // Optional parameter for filtering
  final bool
      displayOnlyFavorites; // Flag to indicate whether to display only favorites
  final GlobalKey<_MusicListViewState> key = GlobalKey<_MusicListViewState>();

  MusicListView({
    required this.height,
    required this.musicList,
    required this.audioplayer,
    required this.datastore,
    this.filterParameter, // Optional parameter for filtering
    this.displayOnlyFavorites = false, // Default is false, meaning display all
  });

  void toggleplay(int i, bool intentflag) {
    _MusicListViewState musicListViewState = key.currentState!;
    musicListViewState.togglePlay(
      i,
      intentflag,
    );
  }

  @override
  _MusicListViewState createState() => _MusicListViewState(datastore);
}

class _MusicListViewState extends State<MusicListView> {
  int? playingIndex;
  Datastore datastore;
  _MusicListViewState(this.datastore);

  @override
  Widget build(BuildContext context) {
    fav = datastore.getFav();
    return Container(
      height: widget.height,
      child: ListView.builder(
        itemCount: widget.musicList.length,
        itemBuilder: (context, index) {
          Map<String, dynamic>? data =
              widget.musicList[index].data() as Map<String, dynamic>?;

          if (data == null) {
            return SizedBox.shrink(); // Skip this item if data is null
          }

          // Check if the filterParameter is provided and matches either albumname, artistname, or musicname
          if (widget.filterParameter != null) {
            String filter = widget.filterParameter!.toLowerCase();
            String artistName = (data['artistname'] ?? '').toLowerCase();
            String albumName = (data['album'] ?? '').toLowerCase();
            String musicName = (data['musicname'] ?? '').toLowerCase();

            if (!(artistName.contains(filter) ||
                albumName.contains(filter) ||
                musicName.contains(filter))) {
              return SizedBox
                  .shrink(); // Skip this item if it doesn't match the filter
            }
          }

          // Check if only favorites should be displayed and if the index is favorited
          if (widget.displayOnlyFavorites && !fav.contains(index)) {
            return SizedBox.shrink(); // Skip this item if it's not a favorite
          }

          return MusicRow(
            index: index,
            height: 80,
            artist: data['artistname'] ?? '',
            musicName: data['musicname'] ?? '',
            time: data['time'] ?? '0',
            musiclink: data['musiclink'] ?? '',
            audioPlayer: widget.audioplayer,
            isPlaying: playingIndex == index,
            onPlayPauseToggle: () {
              togglePlay(index, true);
            },
            datastore: widget.datastore,
          );
        },
      ),
    );
  }

  void togglePlay(int index, bool intentflag) {
    setState(() {
      if (playingIndex == index) {
        // Pause the currently playing item
        playingIndex = null;
        widget.audioplayer.pause();
      } else {
        // Play the selected item
        if (playingIndex != null) {
          // If there is a currently playing item, pause it
          widget.audioplayer.pause();
        }
        datastore.setMusicListViewInstance(widget);
        playingIndex = index;
        widget.audioplayer
            .playFromUrl(widget.musicList[index]['musiclink'] ?? '');
        widget.audioplayer.resume();

        _navigateToMusicPlayingScreen(index, intentflag);
      }
    });
  }

  void _navigateToMusicPlayingScreen(int index, bool intentflag) {
    Map<String, dynamic>? data =
        widget.musicList[index].data() as Map<String, dynamic>?;
    datastore.setCurrentSongDetails(
        data?['musicname'] ?? '',
        data?['artistname'] ?? '',
        data?['album'] ?? '',
        data?['albumcover'] ?? '',
        index);
    if (data != null && intentflag) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MusicPlayingScreen(
            songTitle: data['musicname'] ?? '',
            artistName: data['artistname'] ?? '',
            albumName: data['album'] ?? '',
            albumCover: data['albumcover'] ?? '',
            totalTime: widget.audioplayer.getTotalDuration().toString(),
            audioPlayer: widget.audioplayer,
            index: index,
          ),
        ),
      );
    }
  }
}

class MusicRow extends StatefulWidget {
  final int index;
  final double height;
  final String artist;
  final String musicName;
  final String time;
  final String musiclink;
  final SimpleAudioPlayer audioPlayer;
  final bool isPlaying;
  final VoidCallback onPlayPauseToggle;
  final Datastore datastore;

  MusicRow({
    required this.index,
    required this.height,
    required this.artist,
    required this.musicName,
    required this.time,
    required this.musiclink,
    required this.audioPlayer,
    required this.isPlaying,
    required this.onPlayPauseToggle,
    required this.datastore,
  });

  @override
  State<MusicRow> createState() => _MusicRowState();
}

class _MusicRowState extends State<MusicRow> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Check if the current index is in the fav list
    isFavorite = fav.contains(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
            colors: [
              Color.fromARGB(255, 90, 5, 202),
              Color.fromARGB(255, 90, 5, 202),
              Color.fromARGB(255, 90, 5, 202),
            ],
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  StreamBuilder<bool>(
                    stream: widget.audioPlayer.isPlayingStream,
                    builder: (context, snapshot) {
                      bool isPlaying = snapshot.data ?? false;

                      // Assuming you have artist and songName variables from your data store
                      String artistFromDataStore = widget.datastore
                          .getCurrentArtist(); // Replace with actual artist from data store
                      String songNameFromDataStore = widget.datastore
                          .getCurrentSong(); // Replace with actual song name from data store

                      // Assuming you have access to the current playing artist and song name
                      String currentPlayingArtist = widget.artist;
                      String currentPlayingSongName = widget.musicName;

                      bool shouldPause = (isPlaying &&
                          currentPlayingArtist == artistFromDataStore &&
                          currentPlayingSongName == songNameFromDataStore);

                      return IconButton(
                        icon: Icon(
                          (shouldPause) ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: widget.onPlayPauseToggle,
                      );
                    },
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.artist,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.musicName,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite; // Toggle the favorite state
                        if (isFavorite) {
                          // If favorited, add the index to fav list
                          fav.add(widget.index);
                          widget.datastore.addtofav(widget.index);
                        } else {
                          // If unfavorited, remove the index from fav list
                          fav.remove(widget.index);
                          widget.datastore.removefromfav(widget.index);
                        }
                      });
                      // Handle favorite button action
                    },
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
