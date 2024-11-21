import 'package:flutter/material.dart';
import 'screens/mix_screen.dart'; // MusicPlayer 화면 파일 가져오기

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player', // 앱의 제목
      theme: ThemeData(
        primarySwatch: Colors.blue, // 앱의 기본 테마 색상
      ),
      home: const MixScreen(), // 앱이 실행될 때 첫 화면
    );
  }
}
