import 'package:flutter/material.dart';
import 'package:kickoff/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KickOff',
      theme: ThemeData(
         colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.blueAccent),
      ),
      home: MyHomePage(),
    );
  }
}


