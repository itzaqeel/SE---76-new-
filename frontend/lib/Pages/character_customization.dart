import 'package:flutter/material.dart';
import 'package:frontend/Pages/Navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        bottomNavigationBarTheme: BottomNavigationBarTheme.of(context).copyWith(
          backgroundColor: Colors.black,
          selectedItemColor: const Color.fromRGBO(0, 162, 142, 1).withOpacity(0.7),
          unselectedItemColor: Colors.white,
        ),
       ),
      home: const Character_cust(),
    );
  }
}

// class Character_cust extends StatelessWidget {
class Character_cust extends StatefulWidget {
  const Character_cust({super.key});
  @override
  _Character_custState createState() => _Character_custState();
}

class _Character_custState extends State<Character_cust> {
  String displayedAccessory = 'assets/dog-character_default.png';

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
                )
            ),
          // Title "Choose your Avatar" with rounded white box stroke
          Positioned(
            top: 30,
            left: 50,
            right: 50,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black38.withOpacity(0.5), // Semi-transparent white background
                border: Border.all(color: Colors.white, width: 2.0), // White border
                borderRadius: BorderRadius.circular(18), // Rounded corners
              ),
              child: Text(
                'Customize your character',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15, // Adjusted for space
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Font color changed to black

                ),
              ),
            ),
          ),

          // Accessory container
          Positioned(
            right: 5,
            top: 110,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 120,
                height: 450,
                color: Colors.black38.withOpacity(0.4),
                child: GridView.count(
                  crossAxisCount: 1,
                  padding: EdgeInsets.all(12),
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (index == 0) {
                            displayedAccessory = 'assets/dog_char_access_1.png';
                          } else if (index == 1) {
                            displayedAccessory = 'assets/dog_char_access_2.png';
                          } else {
                            displayedAccessory = 'assets/dog-character_default.png';
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Accessory Locked,Scan to unlock new acccessories'),
                                duration: Duration(milliseconds: 1000),
                              ),
                            );
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white54.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.all(8),
                        child: Center(
                          child: index==0||index==1
                              ?Image.asset(
                                'assets/accessory_${index + 1}.png',
                                fit: BoxFit.cover,
                              )
                              : Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                  size:36 ,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          // Display character images on left-hand side
          if (displayedAccessory.isNotEmpty) // Only display if an accessory is selected
            Positioned(
              left: 10,
              top: 230,
                child: Image.asset(
                  displayedAccessory,
                  width: 270,
                  height: 330,
                  fit: BoxFit.cover,
                ),
              ),
          Positioned(
            left: 80, // Adjust the left position as needed
            bottom: 90, // Adjust the bottom position as needed
            child: ElevatedButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('FOREST GUARDIAN IS READY FOR BATTLE!!'),
                    duration: Duration(seconds: 2), // Adjust the duration as needed
                  ),
                );
                // Wait for the SnackBar to be dismissed
                await Future.delayed(Duration(seconds: 2));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NavBar()),
                );
                },
              child: Text('Customize'),
            ),
          ),

          // // // Bottom navigation bar with notch
          // Positioned(
          //   left: 20, // Adjust the left position as needed
          //   top: 180,
          //   right: 180,
          //   bottom: 160,// Adjust the top position as needed
          //   child: Container(
          //     width: 230,
          //     height: 350,
          //     decoration: const BoxDecoration(
          //       shape: BoxShape.rectangle,
          //       image: DecorationImage(
          //         image: AssetImage('assets/animal-2.png'), // Replace 'assets/character_image.png' with your image path
          //         fit: BoxFit.contain,
          //       ),
          //     ),
          //   ),
          // ),

        ],
      ),
    );
  }
}
