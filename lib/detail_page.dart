import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {

  final int songId;
  final String songTitle;
  final String artistName;

  DetailPage({this.songId, this.songTitle, this.artistName});

  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isLoadiing = true;

  int songId;

  Map song;

  @override
  void initState() {
    this._getSongLyrics();
    super.initState();
  }

  Future<String> _getSongLyrics() async {
    final songID = widget.songId;

    final String uri =
        "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=${songID}&apikey=c603f44e0a2b9abca15b39158bc59beb";

    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});

    setState(() {
      var convertToJson = jsonDecode(response.body);
      song = convertToJson['message']['body']['lyrics'];
      _isLoadiing = false;

      print(song);

    });

    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.songTitle)),
        body: _isLoadiing
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Center(
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(widget.artistName, style: TextStyle(fontWeight: FontWeight.bold)),
                          Divider(),
                          Text(song['lyrics_body']),
                          Divider(),
                          Text(song['lyrics_copyright']),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }
}
