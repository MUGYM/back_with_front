import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playAudio() async {
    await _audioPlayer.play(AssetSource('musics/soulsweeper-252499.mp3'));
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('오디오 플레이어')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _playAudio,
              child: const Text('재생'),
            ),
            ElevatedButton(
              onPressed: _pauseAudio,
              child: const Text('일시정지'),
            ),
            ElevatedButton(
              onPressed: _stopAudio,
              child: const Text('정지'),
            ),
          ],
        ),
      ),
    );
  }
}
