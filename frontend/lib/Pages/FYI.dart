import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/Pages/FYI_data.dart';
import 'package:frontend/Pages/Navigation.dart';
import 'package:frontend/Pages/rotate_card.dart';
import 'package:frontend/Pages/service/database.dart';

void main() {
  runApp(MyApp());
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
      home: FYI(),
    );
  }
}

class FYI extends StatefulWidget {

  @override
  _FYIState createState() => _FYIState();
}

class _FYIState extends State<FYI> with SingleTickerProviderStateMixin {
  final Session session = Session();
  double xp = 0; // Default index



  Future<void> fetchUserCharacter() async {
    try {
      UserModel user = await session.getCurrentUser();
      setState(() {
        xp = user.xp;
      });
    } catch (e) {
      print("Error fetching user character: $e");
    }
  }
  List<Map<String, String>> cardDetails = [];
  late List<Map<String, String>> rewardDetails;
  late List<Map<String, String>> characterList;
  late List<Map<String, String>> fyiList;
  late List<double> xpLevel;
  late AnimationController _controller;
  late bool _isCardFlipped;
  late bool _unlockCharacter;

  @override
  void initState() {
    super.initState();
    initializeCards();
    cardDetails = [];
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _isCardFlipped = false;
    fetchUserCharacter();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void initializeCards() {
    rewardDetails = Rewards.rewardDetails;
    characterList = Rewards.characterList;
    fyiList = Rewards.fyiList;
    xpLevel = Rewards.xpLevels;
    cardDetails = []; // Initialize cardDetails as an empty list

    Random random = Random();
    int index;
    if (xpLevel.contains(xp)) {
      setState(() {
        _unlockCharacter = true;
      });
      // index = 0;
      // cardDetails.add({
      //   'name': characterList[index]['name']!
      // }); // Add character name to cardDetails
    } else {
      setState(() {
        _unlockCharacter = false;
      });
      // index = random.nextInt(rewardDetails.length);
      // cardDetails.add({
      //   'name': rewardDetails[index]['name']!
      // }); // Add reward name to cardDetails
    }
  }

  void _toggleCardFlip() {
    setState(() {
      _isCardFlipped = !_isCardFlipped;
    });
    if (_isCardFlipped) {
      _controller.forward(from: 0.0);
    } else {
      _controller.reverse(from: 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    int index = random.nextInt(fyiList.length);

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/background6.png',
              fit: BoxFit.cover,
            ),
          ),
          // User info container
          // Bottom navigation bar with notch

          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width / 3 *3,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: _toggleCardFlip,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final angle = (_isCardFlipped
                            ? 1 - _controller.value
                            : _controller.value) *
                            3.14;
                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.002)
                            ..rotateY(angle),
                          alignment: Alignment.center,
                          child: child,
                        );
                      },
                      child: Card(
                        color: const Color.fromRGBO(142, 169, 185, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 4.0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (!_isCardFlipped)
                                const Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    'Reward',
                                    style: TextStyle(fontSize: 35.0),
                                  ),
                                ),
                              if (_isCardFlipped)
                                const Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    'Did You Know...',
                                    style: TextStyle(fontSize: 35.0),
                                  ),
                                ),
                              if (_unlockCharacter && !_isCardFlipped)
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: SizedBox(
                                    width:
                                    MediaQuery.of(context).size.width/1.2,
                                    height:
                                    MediaQuery.of(context).size.height / 3,
                                    child: Image.asset(
                                      'assets/RewardFinal.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              if (!_isCardFlipped && !_unlockCharacter)
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: SizedBox(
                                    width:
                                    MediaQuery.of(context).size.width / 1.2,
                                    height:
                                    MediaQuery.of(context).size.height / 3,
                                    child: Image.asset(
                                      'assets/RewardFinal.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              if (_isCardFlipped)
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 0.0),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${fyiList[index]['name']}',
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                        SizedBox(height: 20),
                                        if (_isCardFlipped)
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom:
                                                    16.0), // Adjust the padding as needed
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>NavBar()),
                                                    );
                                                  },
                                                  style: ButtonStyle(
                                                    // backgroundColor: MaterialStateProperty.all(Color.fromRGBO(5,15,21,255)), // Change button color here
                                                    foregroundColor:
                                                    MaterialStateProperty
                                                        .all(Colors
                                                        .cyan), // Change text color here
                                                    minimumSize:
                                                    MaterialStateProperty
                                                        .all(Size(120, 40)),
                                                    textStyle:
                                                    MaterialStateProperty
                                                        .all(TextStyle(
                                                        fontSize: 16)),
                                                  ),
                                                  child: Text(
                                                      'View Card'), // Add your button text here
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}