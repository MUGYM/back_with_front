import 'package:flutter/material.dart';
import 'screens/audio_player_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 오디오 플레이어',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AudioPlayerScreen(),
    );
  }
}
