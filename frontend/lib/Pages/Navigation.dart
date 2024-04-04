import 'package:flutter/material.dart';
import 'package:frontend/Pages/homePageFinal.dart';
import 'package:frontend/Pages/model.dart';
import 'package:frontend/Pages/rotate_card.dart';
import 'package:frontend/Pages/settings.dart';
import 'package:frontend/Pages/user_info.dart';

import '../AR/ar_mystery_box_screen.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: const NavBar(),
    );
  }
}
class NavBar extends StatefulWidget {


  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePageSelector(),
    CharacterCards(),
    UserInfoPage(),
    InstructionsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety_rounded, color: Colors.white),
            label: 'Characters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_sharp, color: Colors.white),
            label: 'Instructions',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.greenAccent,
        onTap: _onItemTapped,
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => mlModel(title: 'Bottle Detection')),
            // MaterialPageRoute(builder: (context) => ArMysteryBoxScreen()),
          );
          print('FloatingActionButton pressed');
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: Icon(Icons.camera_alt_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
// class NavBar extends StatefulWidget {
//   final bool isSigningUp;
//
//   const NavBar({Key? key, required this.isSigningUp}) : super(key: key);
//   @override
//   _NavBarState createState() => _NavBarState();
// }
//
// class _NavBarState extends State<NavBar> {
//   int _selectedIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.isSigningUp ? 0 : 1; // Set initial index based on sign-in status
//   }
//   static const List<Widget> _widgetOptions = <Widget>[
//     Home(),
//     CharacterCards(),
//     UserInfoPage(),
//     InstructionsPage(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed, // Explicitly set the type to fixed
//         backgroundColor: Colors.black, // This will now work as expected
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home, color: Colors.white),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.health_and_safety_rounded,color: Colors.white),
//             label: 'Characters',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person, color: Colors.white),
//             label: 'Profile',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.info_sharp, color: Colors.white),
//             label: 'Instructions',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.greenAccent,
//         onTap: _onItemTapped,
//       ),
//       floatingActionButton: FloatingActionButton(
//       onPressed: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => mlModel(title: 'Bottle Detection')),
//         );
//       // Your action here
//       print('FloatingActionButton pressed');
//     },
//           backgroundColor: Colors.white, // Set the background color to white
//           foregroundColor: Colors.black, // Set the icon color to black
//           child: Icon(Icons.camera_alt_outlined),
//       ),
//
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
// }

//
// class _NavBarState extends State<NavBar> {
//   int _selectedIndex = 0;
//
//   static const List<Widget> _widgetOptions = <Widget>[
//     Home(),
//     CharacterCards(),
//     UserInfoPage(),
//     InstructionsPage(),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     // Directly navigate based on isSigningUp flag when NavBar is first created
//
//       if (widget.isSigningUp) {
//         WidgetsBinding.instance!.addPostFrameCallback((_) {
//           Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => HomeLock()),
//           );
//         });
//       } else {
//         WidgetsBinding.instance!.addPostFrameCallback((_) {
//           Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => Home()),
//           );
//         });
//       }
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     // Navigation logic removed from here
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Navigation Bar Example'),
//       ),
//       body: Center(
//
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.black,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home, color: Colors.white),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.health_and_safety_rounded, color: Colors.white),
//             label: 'Characters',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person, color: Colors.white),
//             label: 'Profile',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.info_sharp, color: Colors.white),
//             label: 'Instructions',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.greenAccent,
//         onTap: _onItemTapped,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => ArMysteryBoxScreen()),
//           );
//         },
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         child: Icon(Icons.camera_alt_outlined),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
// }

// if (widget.isSigningUp) {
// Navigator.of(context).push(
// MaterialPageRoute(builder: (context) => HomeLock()),
// );
// } else {
// Navigator.of(context).push(
// MaterialPageRoute(builder: (context) => Home()),
// );
// }
