import 'package:flutter/material.dart';
import 'package:frontend/Pages/service/build.dart';
import 'card_data.dart';
import 'package:frontend/Pages/Navigation.dart';
import 'character_customization.dart';
import 'navigation.dart';
import 'package:frontend/Pages/service/database.dart';
import 'package:frontend/Pages/service/the xp and hp bar.dart';

// import 'package:flutter/src/material/bottom_app_bar.dart';
import 'package:frontend/Pages/Navigation.dart';

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
      home: const CharacterCards(), // Set the number of cards here
    );
  }
}

class CharacterCards extends StatefulWidget {
  const CharacterCards({super.key});

  @override
  _CharacterCardsState createState() => _CharacterCardsState();
}

class _CharacterCardsState extends State<CharacterCards>
    with SingleTickerProviderStateMixin {
  late List<bool> cardUnlocked;
  late List<String> cardContents;
  late List<Map<String, String>> cardDetails;
  late AnimationController _controller;
  late bool _isCardFlipped;
  late int numCards = 1;
  Session session = Session();

  @override
  void initState() {
    super.initState();
    initializeCards();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _isCardFlipped = false;
    fetchCharacterFromDatabase();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void fetchCharacterFromDatabase() async {
    try {
      UserModel currentUser =
      await Session().getCurrentUser(); // Fetch current user
      if (currentUser != null) {
        setState(() {
          numCards = currentUser.character +
              1; // Set numCards based on the character field in the database
          initializeCards(); // Reinitialize cards based on the updated numCards value
        });
      } else {
        print("Current user is null.");
      }
    } catch (e) {
      print("Error fetching character from database: $e");
    }
  }

  void initializeCards() {
    // Initialize card details using data from card_data.dart
    cardDetails = CardData.cardDetails;

    // Initialize card contents
    cardContents = List<String>.generate(
        numCards, (index) => "Text for card ${index + 1}");

    // Initialize card unlocked status
    cardUnlocked = List<bool>.generate(
        numCards,
            (index) =>
        index != numCards - 1); // Last card is locked, others are unlocked
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

          Center(
            child: XPHPBar(session: session, locaHP: 40, locaXP: 45),
          ),

          Positioned(
            top: 20,
            left: 15,
            child: FutureBuilder<UserModel>(
              future: session.getCurrentUser(),
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 3 * 2,
                  child: Positioned(
                    top: MediaQuery.of(context).size.height / 3 +
                        250, // Adjust the top position as needed
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: PageView.builder(
                        controller: PageController(viewportFraction: 1.0),
                        itemCount: cardContents.length,
                        itemBuilder: (context, index) {
                          return Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 3 * 2,
                              height: MediaQuery.of(context).size.height / 2,
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () => _toggleCardFlip(),
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
                                        color: const Color.fromRGBO(
                                            142, 169, 185, 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(16.0),
                                        ),
                                        elevation: 4.0,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              if (!_isCardFlipped)
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      top: 20.0),
                                                  child: Text(
                                                    '${cardDetails[index]['name']}',
                                                    style: const TextStyle(
                                                        fontSize: 25.0),
                                                  ),
                                                ),
                                              if (!_isCardFlipped)
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                      2,
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                      3,
                                                  child: Image.asset(
                                                    'assets/character_${index + 1}.jpeg',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              if (_isCardFlipped)
                                                Expanded(
                                                  child: Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 20.0,
                                                            horizontal:
                                                            10.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                          children: [
                                                            Text(
                                                              'Habitat: ${cardDetails[index]['habitat']}',
                                                              style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                  16.0),
                                                            ),
                                                            Text(
                                                              'Personality: ${cardDetails[index]['personality']}',
                                                              style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                  16.0),
                                                            ),
                                                            Text(
                                                              'Nutrition Favorite: ${cardDetails[index]['nutritionFavorite']}',
                                                              style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                  16.0),
                                                            ),
                                                            SizedBox(
                                                                height: 20),
                                                          ],
                                                        ),
                                                      ),
                                                      Positioned(
                                                        left: 0,
                                                        right: 0,
                                                        bottom: 20,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.of(context).push(
                                                                  MaterialPageRoute(builder: (context) => Character_cust()),
                                                                );
                                                              },
                                                              style:
                                                              ButtonStyle(
                                                                foregroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                    .cyan),
                                                                minimumSize:
                                                                MaterialStateProperty
                                                                    .all(Size(
                                                                    120,
                                                                    40)),
                                                                textStyle: MaterialStateProperty
                                                                    .all(TextStyle(
                                                                    fontSize:
                                                                    16)),
                                                              ),
                                                              child: Text(
                                                                  'Customize'),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(builder: (context) => HomeScreen()),
                                                                );
                                                              },
                                                              style:
                                                              ButtonStyle(
                                                                foregroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                    .cyan),
                                                                minimumSize:
                                                                MaterialStateProperty
                                                                    .all(Size(
                                                                    120,
                                                                    40)),
                                                                textStyle: MaterialStateProperty
                                                                    .all(TextStyle(
                                                                    fontSize:
                                                                    16)),
                                                              ),
                                                              child: Text(
                                                                  'Select'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (!cardUnlocked[
                                  index]) // Show translucent div if the card is locked
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            16.0), // Same borderRadius as the card
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                          size: 100,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 200, // Change this value to the desired width
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          'You have ${cardUnlocked.where((unlocked) => unlocked).length} unlocked',
                          style: TextStyle(color: Colors.black),
                        ),
                        if (numCards > 1)
                          Text(
                            'Scroll Sideways to View',
                            style: TextStyle(color: Colors.black),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}