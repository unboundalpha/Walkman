import 'dart:math';
import 'package:flutter/material.dart';
import 'package:musicplayer/screens/specificlistpage.dart';

class HorizontalImagesRoll extends StatelessWidget {
  final String heading;
  final int itemCount;
  final double containerWidth;
  final double containerHeight;
  final List<String> images;
  final bool showPlayButton;

  // Make titles and subtitles optional
  final List<String>? titles;
  final List<String>? subtitles;

  HorizontalImagesRoll({
    required this.heading,
    required this.itemCount,
    required this.containerWidth,
    required this.containerHeight,
    required this.images,
    this.showPlayButton = false,
    this.titles,
    this.subtitles,
  });

  @override
  Widget build(BuildContext context) {
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
                color: Colors.white,
                fontFamily: 'satoshi',
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
                // Assuming your images are URLs
                String imageUrl = images[index % images.length];

                // Generate random sizes for containers
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
                      color: Color.fromARGB(255, 90, 5, 202),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Stack(
                      children: [
                        // Image
                        Positioned.fill(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        // Play button (optional)
                        if (showPlayButton)
                          Positioned(
                            top: 8.0,
                            right: 8.0,
                            child: IconButton(
                              icon: Icon(Icons.play_circle_fill),
                              color: Colors.white,
                              iconSize: 32.0,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Specificlistpage(
                                        imageUrl, titles![index]),
                                  ),
                                );
                              },
                            ),
                          ),
                        // Text in a column
                        Positioned(
                          bottom: 8.0,
                          left: 8.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (titles != null && titles!.length > index)
                                Text(
                                  titles![index],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              if (subtitles != null &&
                                  subtitles!.length > index)
                                Text(
                                  subtitles![index],
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
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
}
