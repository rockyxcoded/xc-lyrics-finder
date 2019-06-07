import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './top_songs.dart';
import './detail_page.dart';
import './search_result_screen.dart';

class HomePage extends StatefulWidget {
  //HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoadiing = true;

  String privateKey = DotEnv().env['MM_PRIVATE_KEY'];

  List<dynamic> topSongs;

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    this._getJsonData();
    super.initState();
  }

  Future<String> _getJsonData() async {
    final String uri =
        "https://api.musixmatch.com/ws/1.1/chart.tracks.get?chart_name=top&page=1&page_size=10&country=ng&f_has_lyrics=1&apikey=${this.privateKey}";

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
        title: Text('XC Lyrics Finder'),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.only(right: 50.0),
            onPressed: () {
              setState(() {
                _isLoadiing = true;
              });
              _getJsonData();
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            iconSize: 28.0,
          )
        ],
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
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  contentPadding: const EdgeInsets.all(16.0),
                  content: new Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: myController,
                          autofocus: true,
                          decoration: InputDecoration(
                              // labelText: 'Song title',
                              hintText: 'Enter song title'),
                        ),
                      )
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.pop(context)),
                    FlatButton(
                        child: const Text('Search'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchResultScreen(
                                        songTitle: myController.text
                                      )));
                        })
                  ],
                );
              });
        },
        tooltip: 'search songs',
        child: Icon(Icons.search),
      ),
    );
  }
}
