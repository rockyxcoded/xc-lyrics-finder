import 'package:flutter/material.dart';

class TopSongs extends StatelessWidget {
  final topSongs;

  TopSongs(this.topSongs);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Card(
          child: Container(
            child: Text(
              topSongs['track_name'],
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            padding: const EdgeInsets.all(20.0),
          ),
        ),
      ],
    )));
  }
}
