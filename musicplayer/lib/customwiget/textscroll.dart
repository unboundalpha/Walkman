import 'package:flutter/material.dart';

class SidewaysScrollView extends StatelessWidget {
  final List<String> texts;
  final Function(int) onItemClicked;

  SidewaysScrollView({required this.texts, required this.onItemClicked});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0, // Adjust the height as needed
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: texts
            .asMap()
            .entries
            .map(
              (entry) => SidewaysScrollItem(
                text: entry.value,
                position: entry.key,
                onItemClicked: onItemClicked,
              ),
            )
            .toList(),
      ),
    );
  }
}

class SidewaysScrollItem extends StatelessWidget {
  final String text;
  final int position;
  final Function(int) onItemClicked;

  SidewaysScrollItem({
    required this.text,
    required this.position,
    required this.onItemClicked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Callback to return the position clicked
        onItemClicked(position);
      },
      child: Container(
        margin: EdgeInsets.all(8.0), // Adjust the margin as needed
        padding: EdgeInsets.all(8.0), // Adjust the padding as needed
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius:
              BorderRadius.circular(10.0), // Adjust the radius as needed
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.white,
            ), // Adjust the font size as needed
          ),
        ),
      ),
    );
  }
}
