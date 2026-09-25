import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/demo_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Falls!',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, secondary: const Color.fromARGB(255, 68, 190, 255), tertiary: const Color.fromARGB(255, 71, 68, 255)),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      text: 'Welcome to Water Falls!',
      color: Colors.blue,
      mainAxisAlignment: MainAxisAlignment.center,
      buttons: [
        buildNavButton(context, 'New Game', const NewGame()),
        buildNavButton(context, 'How To Play', const HowToScreen()),
        buildNavButton(context, 'About the Project', const AboutPage()),
      ],
    );
  }
}

class NewGame extends StatelessWidget {
  const NewGame({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      text: 'Item Select',
      color: Colors.blue,
      mainAxisAlignment: MainAxisAlignment.center,
      buttons: [
        buildNavButton(context, 'Game Grid', const GameGrid()),
        buildNavButton(context, 'Main Menu', const MainScreen()),
      ],
    );
  }
}

class GameGrid extends StatelessWidget {
  const GameGrid({super.key});
  @override
  Widget build(BuildContext context) {
    return const SensorHomePage(title: "Game Grid");
  }
}

class HowToScreen extends StatelessWidget {
  const HowToScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      text: 'Welcome to Water Falls! In this game, you can place different items on the grid to create a water flow simulation. Use the controls to add or remove items and watch how the water interacts with them. Have fun experimenting and creating your own water flow scenarios! There are 3 different items to choose from: Water, Dirt, and Air. Water will flow downwards and spread out, Dirt will block the flow of water, and Air will allow water to pass through and overide a block. Enjoy the game!',
      color: Colors.blue,
      mainAxisAlignment: MainAxisAlignment.center,
      buttons: [
        buildNavButton(context, 'Main Menu', const MainScreen()),
      ],
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      text:'This project was created by a team of students as a part of the mobile software development course. The goal of this project was to create a fun game using Terraria inspired water mechanics and flow simulation. While this is far from perfect, we hope that you get some enjoyment out of experimenting with our game. If you have any ideas for improvements please let us know. Have fun and enjoy the game!',
      color: Colors.blue,
      mainAxisAlignment: MainAxisAlignment.center,
      buttons: [
        buildNavButton(context, 'Main Menu', const MainScreen()),
      ],
    );
  }
}

Widget buildNavButton(BuildContext context, String label, Widget destination) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      }, key: Key(label),
      child: Text(label),
    ),
  );
}

class ScreenTemplate extends StatelessWidget {
  final String text;
  final Color color;
  final List<Widget> buttons;
  final MainAxisAlignment mainAxisAlignment;


  const ScreenTemplate({
    super.key,
    required this.text,
    required this.color,
    required this.buttons,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(text),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  height: 2.0,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ...buttons,
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}