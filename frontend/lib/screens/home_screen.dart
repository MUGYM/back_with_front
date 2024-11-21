import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import 'player_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: CustomButton(
          text: 'Go to Player',
          onPressed: () {
            debugPrint("Button clicked!");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PlayerScreen()),
            );
          },
        ),
      ),
    );
  }
}
