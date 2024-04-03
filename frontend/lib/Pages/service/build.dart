import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        bottomNavigationBarTheme: BottomNavigationBarTheme.of(context).copyWith(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.greenAccent,
          unselectedItemColor: Colors.white,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String displayedImage = 'assets/dog-character_default.png';
  Key gifKey = UniqueKey();
  double xp = 0.0;
  double hp = 0.5;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadHP();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const int hpReductionIntervalInMinutes = 5;
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        hp -= 1 / (hpReductionIntervalInMinutes * 60); // 50% HP reduction in hpReductionIntervalInMinutes
        if (hp < 0) hp = 0;
        _saveHP();
      });
    });
  }

  void _loadHP() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      hp = prefs.getDouble('hp') ?? 0.5;
    });
  }

  void _saveHP() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('hp', hp);
  }

  void changeDisplayedImage(String imagePath, int duration) {
    setState(() {
      displayedImage = imagePath;
    });

    Future.delayed(Duration(milliseconds: duration), () {
      setState(() {
        displayedImage = 'assets/dog-character_default.png';
      });
    });
  }

  void increaseXP() {
    setState(() {
      xp += 0.10;
      if (xp > 1.0) xp = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
      Positioned.fill(
      child: Image.asset('assets/backgground.jpg', fit: BoxFit.cover),
    ),
    Positioned(
    left: 80,
    top: 200,
    bottom: 40,
    right: 0,
    child: AnimatedSwitcher(
    duration: Duration(milliseconds: 500),
    child: Image.asset(
    displayedImage,
    key: ValueKey(displayedImage),
    width: 400,
    height: 400,
    ),
    ),
    ),
    Positioned(
    top: 38.0,
    right: 20.0,
    child: Container(
    width: 130.0,
    height: 45.0,
    child: Stack(
    children: [
    Positioned(
    left: 0.0,
    top: 0.0,
    child: Image.asset('assets/hearts.png', width: 24.0, height: 24.0),
    ),
    Positioned(
    left: 30.0,
    top: 3.0,
    right: 2.0,
    bottom: 28.0,
    child: Container(
    decoration: BoxDecoration(border: Border.all(color: Colors.white70, width: 2.0)),
    child: LinearPercentIndicator(
    lineHeight: 20.0,
    percent: hp,
    padding: EdgeInsets.zero,
    backgroundColor: Colors.black54,
    progressColor: Colors.red,
    animation: true,
    animationDuration: 1000,
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    Positioned(
    top: 38.0,
    right: 20.0,
    child: Container(
    width: 130.0,
    height: 45.0,
    child: Stack(
    children: [
    Positioned(
    left: 0.0,
    top:
    25.0,
      child: Image.asset('assets/flash.png', width: 24.0, height: 24.0),
    ),
      Positioned(
        left: 30.0,
        top: 25.0,
        right: 2.0,
        bottom: 3.0,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white70, width: 2.0),
          ),
          child: LinearPercentIndicator(
            lineHeight: 20.0,
            percent: xp,
            padding: EdgeInsets.zero,
            backgroundColor: Colors.black54,
            progressColor: Colors.yellow,
            animation: true,
            animationDuration: 1000,
          ),
        ),
      ),
    ],
    ),
    ),
    ),
// Place other UI components and buttons here as needed
          ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: increaseXP,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}