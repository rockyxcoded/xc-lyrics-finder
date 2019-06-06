import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './top_songs.dart';

Future main() async {
  await DotEnv().load('.env');

  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  //HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoadiing = true;

  String privateKey = DotEnv().env['MM_PRIVATE_KEY'];

  final String uri =
    'https://api.musixmatch.com/ws/1.1/chart.tracks.get?chart_name=top&page=1&page_size=10&country=it&f_has_lyrics=1&apikey=c603f44e0a2b9abca15b39158bc59beb';

  List<dynamic> topSongs;

  @override
  void initState() {
    this._getJsonData();
    super.initState();
  }

  Future<String> _getJsonData() async {
    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});

    if (response.statusCode != 200) {
      throw Exception('Failed to load post');
    }

    setState(() {
      var convertToJson = jsonDecode(response.body);
      topSongs = convertToJson['message']['body']['track_list'];

      _isLoadiing = false;

      print(privateKey);
    });

    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 5.0,
          title: Text('XC Lyric Finder'),
        ),
        body: _isLoadiing
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: topSongs == null ? 0 : topSongs.length,
                itemBuilder: (BuildContext context, int index) {
                  var top = topSongs[index]['track'];
                  return TopSongs(top);
                },
              ));
  }
}
