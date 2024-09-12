import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:mp2/views/yahtzee.dart'; // Ensure this import points to your Yahtzee widget location

void main() {
  runApp(const YahtzeeApp());
}

class YahtzeeApp extends StatelessWidget {
  const YahtzeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yahtzee Game',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.purple[900]),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Yahtzee!'),
        backgroundColor: const Color.fromARGB(255, 235, 232, 232),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Let's Play Yahtzee",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 4, 48, 84),
                shadows: [
                  Shadow(
                    blurRadius: 2.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const FlutterLogo(size: 100),
            const SizedBox(height: 20),
            FAProgressBar(
              currentValue: 100,
              displayText: '% ready',
              displayTextStyle: const TextStyle(color: Colors.white),
              backgroundColor: const Color.fromARGB(255, 242, 244, 248),
              progressColor: Colors.green,
              size: 20,
              animatedDuration: const Duration(milliseconds: 1500),
              direction: Axis.horizontal,
              verticalDirection: VerticalDirection.up,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Yahtzee()));
              },
              icon: const Icon(Icons.gamepad_outlined, size: 14),
              label: const Text('Start Game'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: const TextStyle(fontSize: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Let's roll and get scores!",
              style: TextStyle(
                fontSize: 10,
                fontStyle: FontStyle.italic,
                color: Color.fromARGB(255, 3, 8, 103),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
