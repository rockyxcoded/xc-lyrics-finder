import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './top_songs.dart';
import './detail_page.dart';

class SearchResultScreen extends StatefulWidget {
  final String songTitle;

  SearchResultScreen({Key key, this.songTitle}) : super(key: key);

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  bool _isLoadiing = true;

  String privateKey = DotEnv().env['MM_PRIVATE_KEY'];

  String songTitle; 

  List<dynamic> topSongs;

  @override
  void initState() {
    this.songTitle = widget.songTitle;
    this._getJsonData();
    super.initState();
  }

  Future<String> _getJsonData() async {
    final String uri =
        "http://api.musixmatch.com/ws/1.1/track.search?q_track=${this.songTitle}&apikey=${this.privateKey}";

    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});

    setState(() {
      var convertToJson = jsonDecode(response.body);
      topSongs = convertToJson['message']['body']['track_list'];
      _isLoadiing = false;
    });

    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        title: Text("search result for: ${widget.songTitle}"),
      ),
      body: _isLoadiing
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: topSongs == null ? 0 : topSongs.length,
              itemBuilder: (BuildContext context, int index) {
                var song = topSongs[index]['track'];
                return FlatButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailPage(
                                songId: song['track_id'],
                                songTitle: song['track_name'],
                                artistName: song['artist_name'],
                              )),
                    );
                  },
                  child: TopSongs(song),
                );
              },
            )
    );
  }
}
