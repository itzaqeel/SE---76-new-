import 'package:flutter/material.dart';
import 'package:frontend/Pages/service/database.dart';
import 'package:frontend/Pages/service/the%20xp%20and%20hp%20bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePageSelector(), // Use HomePageSelector as the home page
    );
  }
}
class HomePageSelector extends StatefulWidget {
  const HomePageSelector({super.key});
  @override
  _HomePageSelectorState createState() => _HomePageSelectorState();
}

class _HomePageSelectorState extends State<HomePageSelector> {
  final Session session = Session();
  int homeIndex = 0; // Default index

  @override
  void initState() {
    super.initState();
    fetchUserCharacter();
  }

  Future<void> fetchUserCharacter() async {
    try {
      UserModel user = await session.getCurrentUser();
      setState(() {
        homeIndex = user.character;
      });
    } catch (e) {
      print("Error fetching user character: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return homeIndex == 0 ? HomeLock(session: session) : Home(session: session);
  }
}
class Home extends StatefulWidget {
  final Session session;
  Home({Key? key, required this.session}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String displayedImage = 'assets/dog-character_default.png'; // This variable holds the currently displayed image
  Key gifKey = UniqueKey();


  @override
  void initState() {
    super.initState();
  }
  void changeDisplayedImage(String imagePath, int duration) {
    setState(() {
      displayedImage = imagePath;
    });

    Future.delayed(Duration(milliseconds: duration), () {
      setState(() {
        displayedImage = 'assets/dog-character_default.png'; // Change back to the default image
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/backgground.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
              child: XPHPBar(session: widget.session, locaHP: 50, locaXP: 55),
              ),
          Positioned(
            top: 15,
            left: 15,
            child: FutureBuilder<UserModel>(
              future: widget.session.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  UserModel user = snapshot.data!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Avatar
                      CircleAvatar(
                        radius: 30,
                        child: Image.asset(
                          'assets/avatar${user.avatar}.png',
                        ),

                      ),
                      const SizedBox(width: 10),
                      // Spacing between avatar and text
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                        child: Text(
                          '${user.name}!',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
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
            left: 20,
            top: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Button 1 - Display gif1
                FloatingActionButton(
                  onPressed: () {
                    changeDisplayedImage('assets/output-onlinegiftools.gif', 2500);
                  },
                  backgroundColor: Color(0xFF058743),
                  child: Image.asset(
                    'assets/sugar.png',
                    width: 150,
                    height: 150,
                    key: gifKey, // Pass the gifKey here
                  ),
                ),

                SizedBox(height: 20), // Space between buttons

                // Button 2 - Display gif2



                FloatingActionButton(
                  onPressed: () {
                    changeDisplayedImage('assets/heart1.gif', 2400);
                  },
                  backgroundColor: Color(0xFF058743),
                  child: Image.asset(
                    'assets/hed.png',
                    width: 250,
                    height: 250,
                  ),
                ),
                SizedBox(height: 20), // Space between buttons

                // Third button with lock
                Stack(
                  alignment: Alignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        // Show a dialog notification when the button is pressed
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Center( // Center the title
                                child: Text(
                                  'Unlock at level 7',
                                  style: TextStyle(fontSize: 14), // Adjust font size
                                ),
                              ),
                              content: Container(
                                height: 8, // Adjust height
                              ),
                              actions: [
                                Center( // Center the button
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'OK',
                                      style: TextStyle(fontSize: 12), // Adjust font size
                                    ),
                                  ),
                                ),
                              ],
                              contentPadding: EdgeInsets.all(5), // Adjust padding
                            );
                          },
                        );
                      },
                      backgroundColor: Color(0xFF058743),
                      child: Image.asset(
                        'assets/dances.png',
                        width: 50,
                        height: 50,
                      ),
                    ),
                    Icon(Icons.lock, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class HomeLock extends StatefulWidget {
  final Session session;
  HomeLock({Key? key, required this.session}) : super(key: key);
  @override
  _HomeLockState createState() => _HomeLockState();
}

class _HomeLockState extends State<HomeLock> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/backgground.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 15,
            left: 15,
            child: FutureBuilder<UserModel>(
              future: widget.session.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  UserModel user = snapshot.data!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Avatar
                      CircleAvatar(
                        radius: 30,
                        child: Image.asset(
                          'assets/avatar${user.avatar}.png',
                        ),

                      ),
                      const SizedBox(width: 10),
                      // Spacing between avatar and text
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                        child: Text(
                          '${user.name}!',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.5, // Adjust the opacity as needed
              child: Container(
                color: Colors.black, // Semi-transparent black background
                child: Center(
                  child: Text(
                    "No characters unlocked!"
                        " Please dispose to unlock",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
