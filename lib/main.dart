import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

import './home_page.dart';


Future main() async {
  await DotEnv().load('.env');

  runApp(MaterialApp(
    home: HomePage(),
  ));
}

