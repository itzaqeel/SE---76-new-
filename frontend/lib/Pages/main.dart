import 'package:flutter/material.dart';
import 'package:frontend/Pages/homePageFinal.dart';
import 'splash.dart';
import 'character_customization.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      // Define initial route for loading the first screen
      initialRoute: '/splash',

      routes: {
        '/splash': (context) => const Splash(),
        '/homescreen': (context) =>  HomePageSelector(), // Use HomeScreen from Page2
        '/character_customization': (context) =>
            Character_cust(), // Use HomeScreen from Page3
        // '/cameraview': (context) => const CameraView(),
      },
    );
  }
}

