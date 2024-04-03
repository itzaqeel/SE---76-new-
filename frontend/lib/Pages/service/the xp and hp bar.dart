// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:percent_indicator/percent_indicator.dart';
// import 'package:frontend/Pages/service/database.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class XPHPBar extends StatefulWidget {
//   final Session session;
//   final double? locaHP;
//   final double? locaXP;
//
//   const XPHPBar({Key? key, required this.session, this.locaHP, this.locaXP})
//       : super(key: key);
//
//   @override
//   _XPHPBarState createState() => _XPHPBarState();
// }
//
// class _XPHPBarState extends State<XPHPBar> {
//   late Timer _timer;
//   double xp = 0.0; // Initial XP value
//   double hp = 1; // Initial HP value
//   static const int hpReductionIntervalInMinutes =
//       5; // Interval for HP reduction
//
//   @override
//   void initState() {
//     super.initState();
//     // Load HP and XP from Firestore
//     _loadUserData();
//     // Start timer to reduce HP over time
//     _startTimer();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _timer.cancel(); // Cancel timer to avoid memory leaks
//   }
//
//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
//       // Reduce HP periodically
//       setState(() {
//         hp -= 1 /
//             (hpReductionIntervalInMinutes *
//                 2); // 50% HP reduction in hpReductionIntervalInMinutes minutes
//         if (hp < 0) {
//           hp = 0; // Ensure HP doesn't go below 0
//         }
//         print('HP: $hp'); // Print HP value for debugging
//         // Save HP to Firestore
//         _updateHP();
//       });
//     });
//   }
//
//   void _loadUserData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       UserModel user = await widget.session.getCurrentUser();
//       setState(() {
//         hp = user.hp / 100;
//         hp = prefs.getDouble('hp') ?? hp;
//         xp = user.xp.toDouble();
//       });
//     } catch (e) {
//       print('Error loading user data: $e');
//     }
//   }
//
//   void _updateHP() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       UserModel user = await widget.session.getCurrentUser();
//       user.hp = (hp * 100).toInt();
//       prefs.setDouble('hp', hp);
//       await widget.session.updateUserData(user);
//     } catch (e) {
//       print('Error updating HP: $e');
//     }
//   }
//
//   void increaseXP() {
//     setState(() {
//       // Increase XP by 10%
//       xp += 0.10;
//       if (xp > 1.0) {
//         xp = 1.0; // Cap XP at 100%
//       }
//     });
//     // Update XP in Firestore
//     _updateXP();
//   }
//
//   void _updateXP() async {
//     try {
//       UserModel user = await widget.session.getCurrentUser();
//       user.xp = xp;
//       await widget.session.updateUserData(user);
//     } catch (e) {
//       print('Error updating XP: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // HP Indicator
//         Positioned(
//           top: widget.locaHP,
//           right: 20.0,
//           child: Container(
//             width: 130.0,
//             height: 45.0,
//             child: Stack(
//               children: [
//                 Positioned(
//                   left: 0.0,
//                   top: 0.0,
//                   child: Image.asset('assets/hearts.png',
//                       width: 24.0, height: 24.0),
//                 ),
//                 Positioned(
//                   left: 30.0,
//                   top: 3.0,
//                   right: 2.0,
//                   bottom: 28.0,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.white70, width: 2.0),
//                     ),
//                     child: LinearPercentIndicator(
//                       lineHeight: 20.0,
//                       percent: hp,
//                       padding: EdgeInsets.zero,
//                       backgroundColor: Colors.black54,
//                       progressColor: Colors.red,
//                       animation: true,
//                       animationDuration: 1000,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         // XP Indicator
//         Positioned(
//           top: widget.locaXP,
//           right: 20.0,
//           child: Container(
//             width: 130.0,
//             height: 45.0,
//             child: Stack(
//               children: [
//                 Positioned(
//                   left: 0.0,
//                   top: 25.0,
//                   child: Image.asset('assets/flash.png',
//                       width: 24.0, height: 24.0),
//                 ),
//                 Positioned(
//                   left: 30.0,
//                   top: 25.0,
//                   right: 2.0,
//                   bottom: 3.0,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.white70, width: 2.0),
//                     ),
//                     child: LinearPercentIndicator(
//                       lineHeight: 20.0,
//                       percent: xp,
//                       padding: EdgeInsets.zero,
//                       backgroundColor: Colors.black54,
//                       progressColor: Colors.yellow,
//                       animation: true,
//                       animationDuration: 1000,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:frontend/Pages/service/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class XPHPBar extends StatefulWidget {
  final Session session;
  final double? locaHP;
  final double? locaXP;

  const XPHPBar({Key? key, required this.session, this.locaHP, this.locaXP})
      : super(key: key);

  @override
  _XPHPBarState createState() => _XPHPBarState();
}

class _XPHPBarState extends State<XPHPBar> {
  late Timer _timer;
  double xp = 0.0; // Initial XP value
  double hp = 1; // Initial HP value
  static const int hpReductionIntervalInMinutes =
  5; // Interval for HP reduction

  @override
  void initState() {
    super.initState();
    // Load HP and XP from Firestore
    _loadUserData();
    // Start timer to reduce HP over time
    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel(); // Cancel timer to avoid memory leaks
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      // Reduce HP periodically
      setState(() {
        hp -= 1 /
            (hpReductionIntervalInMinutes *
                2); // 50% HP reduction in hpReductionIntervalInMinutes minutes
        if (hp < 0) {
          hp = 0; // Ensure HP doesn't go below 0
        }
        print('HP: $hp'); // Print HP value for debugging
        // Save HP to Firestore
        _updateHP();
      });
    });
  }

  void _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      UserModel user = await widget.session.getCurrentUser();
      setState(() {
        hp = user.hp / 100;
        xp = user.xp;
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  void _updateHP() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      UserModel user = await widget.session.getCurrentUser();
      user.hp = (hp * 100);
      prefs.setDouble('hp', hp);
      await widget.session.updateUserData(user);
    } catch (e) {
      print('Error updating HP: $e');
    }
  }

  void increaseXP() {
    setState(() {
      // Increase XP by 10%
      xp += 0.10;
      if (xp > 1.0) {
        xp = 1.0; // Cap XP at 100%
      }
    });
    // Update XP in Firestore
    _updateXP();
  }

  void _updateXP() async {
    try {
      UserModel user = await widget.session.getCurrentUser();
      user.xp = xp;
      await widget.session.updateUserData(user);
    } catch (e) {
      print('Error updating XP: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // HP Indicator
        Positioned(
          top: widget.locaHP,
          right: 20.0,
          child: Container(
            width: 130.0,
            height: 45.0,
            child: Stack(
              children: [
                Positioned(
                  left: 0.0,
                  top: 0.0,
                  child: Image.asset('assets/hearts.png',
                      width: 24.0, height: 24.0),
                ),
                Positioned(
                  left: 30.0,
                  top: 3.0,
                  right: 2.0,
                  bottom: 28.0,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white70, width: 2.0),
                    ),
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
        // XP Indicator
        Positioned(
          top: widget.locaXP,
          right: 20.0,
          child: Container(
            width: 130.0,
            height: 45.0,
            child: Stack(
              children: [
                Positioned(
                  left: 0.0,
                  top: 25.0,
                  child: Image.asset('assets/flash.png',
                      width: 24.0, height: 24.0),
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
      ],
    );
  }
}