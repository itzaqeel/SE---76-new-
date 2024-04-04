import 'package:flutter/material.dart';

void main() {
  runApp(InstructionsPage());
}

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({super.key});
  @override
  Widget build(BuildContext context) {

    final double bottomNavigationBarHeight = MediaQuery.of(context).padding.bottom;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack( // Use Stack to layer the background image and content
          children: [
            Positioned.fill( // Positioned.fill to occupy the whole screen
              child: Image.asset( // Background image
                'assets/backgground.jpg', // Replace with your background image asset path
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
            SingleChildScrollView( // Wrap with SingleChildScrollView
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start, // Align children to the start
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 65), // Add some space on top
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
                      decoration: BoxDecoration(
                        color: Colors.black38.withOpacity(0.5), // Semi-transparent black background
                        border: Border.all(color: Colors.white, width: 2.0), // White border
                        borderRadius: BorderRadius.circular(15), // Rounded corners
                      ),
                      child: Text(
                        'Game Instructions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/Step 01 (1).png', // Replace with your image asset path
                      height: 365, // Adjust height as needed
                      width: 365, // Adjust width as needed
                    ),
                    Image.asset(
                      'assets/step222.png', // Replace with your image asset path
                      height: 365, // Adjust height as needed
                      width: 365, // Adjust width as needed
                    ),
                    Image.asset(
                      'assets/step 3.png', // Replace with your image asset path
                      height: 365, // Adjust height as needed
                      width: 365, // Adjust width as needed
                    ),
                    SizedBox(height: 15), // Add space between the images and the text
                    Text(
                      'Customize your character and explore the world!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: bottomNavigationBarHeight), // Add space for the bottom navigation bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
