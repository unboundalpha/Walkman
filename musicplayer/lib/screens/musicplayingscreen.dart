import 'package:flutter/material.dart';
import 'package:musicplayer/customwiget/musicrow.dart';
import 'package:musicplayer/funtions/Audioplayer.dart';
import 'package:musicplayer/funtions/datastore.dart';

class MusicPlayingScreen extends StatefulWidget {
  final String songTitle;
  final String artistName;
  final String albumName;
  final String albumCover;
  final String totalTime;
  final SimpleAudioPlayer audioPlayer;
  final int index;

  MusicPlayingScreen(
      {required this.songTitle,
      required this.artistName,
      required this.albumName,
      required this.albumCover,
      required this.totalTime,
      required this.audioPlayer,
      required this.index});

  @override
  State<MusicPlayingScreen> createState() => _MusicPlayingScreenState();
}

class _MusicPlayingScreenState extends State<MusicPlayingScreen> {
  bool isPlaying = false;
  double progressValue = 0.0;
  String elapsedTime = "0:00";
  late Datastore datastore;
  late MusicListView instaceoflistview;
  @override
  void initState() {
    super.initState();

    datastore = Datastore();
    datastore.setCurrentSongDetails(widget.songTitle, widget.artistName,
        widget.albumName, widget.albumCover, widget.index);
    instaceoflistview = datastore.getMusicListViewInstance()!;
    // Set the callback for updating progress bar
    widget.audioPlayer.setOnTimeElapsedPercentageCallback(
        (double percentage, Duration elapsed) {
      setState(() {
        progressValue = percentage / 100.0;

        // Calculate elapsed time in minutes
        int minutes = elapsed.inMinutes;
        int seconds = (elapsed.inSeconds % 60).toInt();
        elapsedTime = '$minutes:${seconds < 10 ? '0$seconds' : '$seconds'}';
      });
    });
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
              color: Color.fromARGB(255, 90, 5, 202),
              fontFamily: "walkman",
              fontSize: 30,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF070707),
          elevation: 0.0,
          flexibleSpace: ClipPath(
            clipper: BottomCurveClipper(),
            child: Container(
              color: Color(0xFF070707),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.songTitle,
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                  SizedBox(height: 20),
                  Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromARGB(255, 90, 5, 202),
                    ),
                    child: Image.network(
                      widget.albumCover,
                      width: 400,
                      height: 400,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.artistName,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              Text(widget.albumName,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Handle favorite button action
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(elapsedTime),
                      Text(widget.audioPlayer.getTotalDuration()),
                    ],
                  ),
                  SizedBox(height: 10),
                  Slider(
                    value: progressValue,
                    onChanged: (double value) {
                      _updateSliderValue(value);
                    },
                    onChangeEnd: (double value) {
                      _handleSliderChangeEnd(value);
                    },
                    min: 0.0,
                    max: 1.1, // Set the maximum value to 1.1
                    activeColor: Color.fromARGB(255, 90, 5, 202),
                    inactiveColor: Colors.black,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.repeat, color: Colors.white),
                  onPressed: () {
                    // Handle repeat button action
                  },
                ),
                IconButton(
                  icon: Icon(Icons.skip_previous, color: Colors.white),
                  onPressed: () {
                    // Handle previous button action
                    Navigator.pop(context);
                    instaceoflistview.toggleplay(widget.index + 1, true);
                  },
                ),
                Center(
                  child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 90, 5, 202),
                      ),
                      child: StreamBuilder<bool>(
                        stream: widget.audioPlayer.isPlayingStream,
                        builder: (context, snapshot) {
                          bool isPlaying = snapshot.data ?? false;
                          return IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (isPlaying) {
                                widget.audioPlayer.pause();
                              } else {
                                widget.audioPlayer.resume();
                              }
                            },
                          );
                        },
                      )),
                ),
                IconButton(
                  icon: Icon(Icons.skip_next, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                    instaceoflistview.toggleplay(widget.index + 1, true);

                    // Handle next button action
                  },
                ),
                IconButton(
                  icon: Icon(Icons.shuffle, color: Colors.white),
                  onPressed: () {
                    // Handle shuffle button action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateSliderValue(double value) {
    setState(() {
      progressValue = value;
    });

    // Seek to the selected position
    widget.audioPlayer.seek(value as Duration);

    // Handle reaching the maximum value
    if (value == 1.0) {
      Navigator.pop(context);
      instaceoflistview.toggleplay(widget.index + 1, true);
    }
  }

  void _handleSliderChangeEnd(double value) {
    // Handle the end of dragging
    widget.audioPlayer.seek(value as Duration);

    // Additional logic at the end of dragging, if needed
  }
}

String formatTime(String rawTime) {
  int seconds = int.tryParse(rawTime) ?? 0;
  int minutes = seconds ~/ 60;
  seconds %= 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 30);

    final double curveHeight = 30.0;
    final double curveWidth = size.width * 0.25;

    path.quadraticBezierTo(size.width / 2 - curveWidth / 2, size.height,
        size.width / 2, size.height);
    path.quadraticBezierTo(size.width / 2 + curveWidth / 2, size.height,
        size.width, size.height - 30);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
