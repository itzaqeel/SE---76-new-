import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:frontend/login/screens/update_screen.dart';
import 'package:frontend/login/screens/login_screen.dart';
import 'package:frontend/Pages/service/the xp and hp bar.dart';
import 'package:frontend/Pages/avatar_cust.dart';
import 'package:frontend/Pages/service/database.dart';
import '../login/utils/helpers/snackbar_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        bottomNavigationBarTheme: BottomNavigationBarTheme.of(context).copyWith(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.greenAccent,
          unselectedItemColor: Colors.white,
        ),
      ),
      home: const UserInfoPage(),
    );
  }
}

final _auth = FirebaseAuth.instance;
final _db = FirebaseFirestore.instance;
User? currentuser = FirebaseAuth.instance.currentUser;

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late Future<GetUserInfo> _userDataFuture;
  String selectedImage = "";
  String avatarEmoji = "";

  Session session = Session();
  late int index = 1;

  void fetchAndSetAvatar() async {
    UserModel currentUser = await session.getCurrentUser();
    if (currentUser != null) {
      setState(() {
        index = currentUser
            .avatar; // Set the index based on the fetched character value
        selectOption(index); // Update the selectedImage based on the index
      });
    }
  }

  void selectOption(int optionIndex) async {
    setState(() {
      index = optionIndex; // Update the value of index
    });

    setState(() {
      // Update selectedImage based on the index
      switch (index) {
        case 1:
          selectedImage = 'assets/halfsen.png';
          avatarEmoji = 'assets/avatar1.png';
          break;
        case 2:
          selectedImage = 'assets/halfaq.png';
          avatarEmoji = 'assets/avatar2.png';
          break;
        case 3:
          selectedImage = 'assets/halfdin.png';
          avatarEmoji = 'assets/avatar3.png';
          break;
        case 4:
          selectedImage = 'assets/halfmin.png';
          avatarEmoji = 'assets/avatar4.png';
          break;
        case 5:
          selectedImage = 'assets/halfay.png';
          avatarEmoji = 'assets/avatar5.png';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _userDataFuture = getUserData();
    fetchAndSetAvatar();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          // Top half background color
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight / 3 - 20,
              color: const Color.fromRGBO(0, 162, 142, 1),
              child: Center(
                child: Hero(
                  tag: 'selectedAvatar',
                  child: Image.asset(
                    selectedImage,
                    width: screenWidth,
                    height: screenHeight/ 3 - 20,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top:
             screenHeight / 5 + 20, // Adjust as needed
            left:
             screenWidth / 2 + 30, // Adjust as needed
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AvatartCust()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text('Customize'),
            ),
          ),

          Positioned(
            top: screenHeight / 3,
            left: 20,
            child: FutureBuilder<GetUserInfo>(
              future: _userDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator while fetching data
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final userData = snapshot.data!;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          AssetImage(
                              avatarEmoji), // Use appropriate avatar URL
                    ),
                    const SizedBox(width: 10),
                    Text(
                      userData.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          Center(
            child: XPHPBar(
                session: session,
                locaHP: screenHeight / 3 + 3,
                locaXP: screenHeight / 3 +
                    5), // Call the method here
          ),

          // Display User Information
          Positioned(
            top: screenHeight / 3 + 75,
            left: 20,
            right: 20,
            child: FutureBuilder<GetUserInfo>(
              future: _userDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator while fetching data
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final userData = snapshot.data!;
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${userData.name}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Divider(color: Colors.grey),
                      Text(
                        'Email: ${userData.email}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Divider(color: Colors.grey),
                      Text(
                        'Password: ${userData.password}', // Displaying password is not recommended for security reasons
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Log Out Button
          Positioned(
            top: screenHeight / 3 + 220,
            left: 20,
            right: 20,
            child: Container(
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await _auth.signOut(); // Sign out the user
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const LoginPage()), // Navigate to the login page
                    );
                  } catch (error) {
                    print('Error logging out: $error');
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Log Out'),
              ),
            ),
          ),

          // Log Out Button
          Positioned(
            top: screenHeight / 3 + 220,
            left: 20,
            right: 20,
            child: Container(
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await _auth.signOut(); // Sign out the user
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const LoginPage()), // Navigate to the login page
                    );
                  } catch (error) {
                    print('Error logging out: $error');
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Log Out'),
              ),
            ),
          ),

          // Update Password Button
          Positioned(
            top: screenHeight / 3 + 280,
            left: 20,
            right: 20,
            child: Container(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UpdatePasswordPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Update Password'),
              ),
            ),
          ),

          // Delete Account Button
          Positioned(
            top: screenHeight / 3 + 340,
            left: 20,
            right: 20,
            child: Container(
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  // Add functionality for deleting account
                  try {
                    // Delete user data from Firestore
                    final email = currentuser?.email;
                    final snapshot = await _db
                        .collection("User")
                        .where("Email", isEqualTo: email)
                        .get();
                    snapshot.docs.forEach((doc) {
                      doc.reference.delete();
                    });

                    // Delete user account from FirebaseAuth
                    await currentuser?.delete();

                    // Navigate to login screen after successful deletion
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );

                    // Show a Snackbar message indicating successful deletion
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('The Account Was Deleted Successfully'),
                      ),
                    );
                    // Navigate to login screen
                  } catch (error) {
                    print('Error deleting account: $error');
                    // Handle error
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Delete Account'),
              ),
            ),
          ),

          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
                height: 300), // Add SizedBox below the delete account button
          ),
        ],
      ),
    );
  }

  Future<GetUserInfo> getUserData() async {
    final email = currentuser?.email;
    final snapshot =
        await _db.collection("User").where("Email", isEqualTo: email).get();
    final userData =
        snapshot.docs.map((e) => GetUserInfo.fromSnapshot(e)).single;
    return userData;
  }
}
//
class UserInfo extends StatelessWidget {
  final String avatarUrl;
  final String userName;

  const UserInfo({
    Key? key,
    required this.avatarUrl,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        const SizedBox(width: 20), // Spacing between avatar and text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(
                userName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ), // Vertical spacing between name and level
          ],
        ),
      ],
    );
  }
}

class GetUserInfo {
  final String name;
  final String email;
  final String password;

  const GetUserInfo({
    required this.name,
    required this.email,
    required this.password,
  });

  factory GetUserInfo.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return GetUserInfo(
      name: data["Name"],
      email: data["Email"],
      password: data["Password"],
    );
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:frontend/login/screens/update_screen.dart';
// import 'package:frontend/login/screens/login_screen.dart';
// import 'package:frontend/Pages/service/the xp and hp bar.dart';
// import 'package:frontend/Pages/avatar_cust.dart';
// import 'package:frontend/Pages/service/database.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.light().copyWith(
//         bottomNavigationBarTheme: BottomNavigationBarTheme.of(context).copyWith(
//           backgroundColor: Colors.black,
//           selectedItemColor: Colors.greenAccent,
//           unselectedItemColor: Colors.white,
//         ),
//       ),
//       home: const UserInfoPage(),
//     );
//   }
// }
//
// final _auth = FirebaseAuth.instance;
// final _db = FirebaseFirestore.instance;
// User? currentuser = FirebaseAuth.instance.currentUser;
//
// class UserInfoPage extends StatefulWidget {
//   const UserInfoPage({Key? key}) : super(key: key);
//
//   @override
//   _UserInfoPageState createState() => _UserInfoPageState();
// }
//
// class _UserInfoPageState extends State<UserInfoPage> {
//   late Future<GetUserInfo> _userDataFuture;
//   String selectedImage = "";
//   String avatarEmoji = "";
//
//   Session session = Session();
//   late int index = 1;
//
//   void fetchAndSetAvatar() async {
//     UserModel currentUser = await session.getCurrentUser();
//     if (currentUser != null) {
//       setState(() {
//         index = currentUser
//             .avatar; // Set the index based on the fetched character value
//         selectOption(index); // Update the selectedImage based on the index
//       });
//     }
//   }
//
//   void selectOption(int optionIndex) async {
//     setState(() {
//       index = optionIndex; // Update the value of index
//     });
//
//     setState(() {
//       // Update selectedImage based on the index
//       switch (index) {
//         case 1:
//           selectedImage = 'assets/halfsen.png';
//           avatarEmoji = 'assets/avatar1.png';
//           break;
//         case 2:
//           selectedImage = 'assets/halfaq.png';
//           avatarEmoji = 'assets/avatar2.png';
//           break;
//         case 3:
//           selectedImage = 'assets/halfdin.png';
//           avatarEmoji = 'assets/avatar3.png';
//           break;
//         case 4:
//           selectedImage = 'assets/halfmin.png';
//           avatarEmoji = 'assets/avatar4.png';
//           break;
//         case 5:
//           selectedImage = 'assets/halfay.png';
//           avatarEmoji = 'assets/avatar5.png';
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _userDataFuture = getUserData();
//     fetchAndSetAvatar();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Top half background color
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: MediaQuery.of(context).size.height / 3 - 20,
//               color: const Color.fromRGBO(0, 162, 142, 1),
//               child: Center(
//                 child: Hero(
//                   tag: 'selectedAvatar',
//                   child: Image.asset(
//                     selectedImage,
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height / 3 - 20,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           Positioned(
//             top:
//             MediaQuery.of(context).size.height / 5 + 20, // Adjust as needed
//             left:
//             MediaQuery.of(context).size.width / 2 + 30, // Adjust as needed
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => AvatartCust()),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.black,
//                 backgroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//               child: Text('Customize'),
//             ),
//           ),
//
//           Positioned(
//             top: MediaQuery.of(context).size.height / 3,
//             left: 20,
//             child: FutureBuilder<GetUserInfo>(
//               future: _userDataFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator(); // Show loading indicator while fetching data
//                 }
//                 if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 }
//                 final userData = snapshot.data!;
//                 return Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundImage:
//                       AssetImage(avatarEmoji), // Use appropriate avatar URL
//                     ),
//                     const SizedBox(width: 10),
//                     Text(
//                       userData.name,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//
//           Center(
//             child: XPHPBar(
//                 session: session,
//                 locaHP: MediaQuery.of(context).size.height / 3 + 3,
//                 locaXP: MediaQuery.of(context).size.height / 3 +
//                     5), // Call the method here
//           ),
//
//           // Display User Information
//           Positioned(
//             top: MediaQuery.of(context).size.height / 3 + 75,
//             left: 20,
//             right: 20,
//             child: FutureBuilder<GetUserInfo>(
//               future: _userDataFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator(); // Show loading indicator while fetching data
//                 }
//                 if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 }
//                 final userData = snapshot.data!;
//                 return Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.black, width: 2),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Name: ${userData.name}',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       const Divider(color: Colors.grey),
//                       Text(
//                         'Email: ${userData.email}',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       const Divider(color: Colors.grey),
//                       Text(
//                         'Password: ${userData.password}', // Displaying password is not recommended for security reasons
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           // Log Out Button
//           Positioned(
//             top: MediaQuery.of(context).size.height / 3 + 220,
//             left: 20,
//             right: 20,
//             child: Container(
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   try {
//                     await _auth.signOut(); // Sign out the user
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                           const LoginPage()), // Navigate to the login page
//                     );
//                   } catch (error) {
//                     print('Error logging out: $error');
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.grey,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text('Log Out'),
//               ),
//             ),
//           ),
//
//           // Update Password Button
//           Positioned(
//             top: MediaQuery.of(context).size.height / 3 + 280,
//             left: 20,
//             right: 20,
//             child: Container(
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const UpdatePasswordPage()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.blue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text('Update Password'),
//               ),
//             ),
//           ),
//
//           // Delete Account Button
//           Positioned(
//             top: MediaQuery.of(context).size.height / 3 + 340,
//             left: 20,
//             right: 20,
//             child: Container(
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   // Add functionality for deleting account
//                   try {
//                     // Delete user data from Firestore
//                     final email = currentuser?.email;
//                     final snapshot = await _db
//                         .collection("User")
//                         .where("Email", isEqualTo: email)
//                         .get();
//                     snapshot.docs.forEach((doc) {
//                       doc.reference.delete();
//                     });
//
//                     // Delete user account from FirebaseAuth
//                     await currentuser?.delete();
//
//                     // Navigate to login screen after successful deletion
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const LoginPage()),
//                     );
//
//                     // Show a Snackbar message indicating successful deletion
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('The Account Was Deleted Successfully'),
//                       ),
//                     );
//                     // Navigate to login screen
//                   } catch (error) {
//                     print('Error deleting account: $error');
//                     // Handle error
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.red,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text('Delete Account'),
//               ),
//             ),
//           ),
//
//           const Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: SizedBox(
//                 height: 300), // Add SizedBox below the delete account button
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<GetUserInfo> getUserData() async {
//     final email = currentuser?.email;
//     final snapshot =
//     await _db.collection("User").where("Email", isEqualTo: email).get();
//     final userData =
//         snapshot.docs.map((e) => GetUserInfo.fromSnapshot(e)).single;
//     return userData;
//   }
// }
//
// class UserInfo extends StatelessWidget {
//   final String avatarUrl;
//   final String userName;
//
//   const UserInfo({
//     Key? key,
//     required this.avatarUrl,
//     required this.userName,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         CircleAvatar(
//           radius: 30,
//           backgroundImage: NetworkImage(avatarUrl),
//         ),
//         const SizedBox(width: 20), // Spacing between avatar and text
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(4),
//               decoration: const BoxDecoration(
//                 color: Colors.black,
//                 borderRadius: BorderRadius.all(Radius.circular(10)),
//               ),
//               child: Text(
//                 userName,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 5,
//             ), // Vertical spacing between name and level
//           ],
//         ),
//       ],
//     );
//   }
// }
//
// class GetUserInfo {
//   final String name;
//   final String email;
//   final String password;
//
//   const GetUserInfo({
//     required this.name,
//     required this.email,
//     required this.password,
//   });
//
//   factory GetUserInfo.fromSnapshot(
//       DocumentSnapshot<Map<String, dynamic>> document) {
//     final data = document.data()!;
//     return GetUserInfo(
//       name: data["Name"],
//       email: data["Email"],
//       password: data["Password"],
//     );
//   }
// }