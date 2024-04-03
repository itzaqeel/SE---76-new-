import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseMethods {
  Future<void> addUserData(Map<String, dynamic> userMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('User')
        .doc(id)
        .set(userMap);
  }














  Future<Stream<QuerySnapshot>> getUserData(String uid) async {
    return await FirebaseFirestore.instance.collection('User').snapshots();
  }
}

class UserModel {
  int accessory;
  int avatar;
  int character;
  String email;
  double hp;
  int level;
  String name;
  int nutrition;
  String password;
  double xp;

  UserModel({
    this.accessory = 0,
    this.avatar = 0,
    this.character = 0,
    this.email = '',
    this.hp = 100,
    this.level = 1,
    this.name = '',
    this.nutrition = 0,
    this.password = '',
    this.xp = 0,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      accessory: data['Accessory'] ?? 0,
      avatar: data['Avatar'] ?? 0,
      character: data['Character'] ?? 0,
      email: data['Email'] ?? '',
      hp: data['HP'] ?? 100,
      level: data['Level'] ?? 1,
      name: data['Name'] ?? '',
      nutrition: data['Nutrition'] ?? 0,
      password: data['Password'] ?? '',
      xp: data['XP'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Accessory': accessory,
      'Avatar': avatar,
      'Character': character,
      'Email': email,
      'HP': hp,
      'Level': level,
      'Name': name,
      'Nutrition': nutrition,
      'Password': password,
      'XP': xp,
    };
  }
}

class Session {
  UserModel? currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print('User logged in with email: $email');
      await fetchUserData(userCredential.user!.uid);
    } catch (e) {
      print("Error logging in: $e");
    }
  }
//METHOD TO AUTHENTICATE USER AND FIND CURRENT USER
  Future<void> logoutUser() async {
    print('User logging out: ${_auth.currentUser?.email}');
    await _auth.signOut();
    currentUser = null;
    print('User logged out successfully');
  }
  Future<UserModel> getCurrentUser() async {
    if (_auth.currentUser != null) {
      await fetchUserData(_auth.currentUser!.uid);
      return currentUser!;
    } else {
      throw Exception("No user is currently logged in.");
    }
  }
  //METHOD TO RETRIEVE
  Future<void> fetchUserData(String uid) async {
    print('Fetching user data for UID: $uid');
    DocumentSnapshot userDoc = await _firestore.collection('User').doc(uid).get();
    if (userDoc.exists) {
      currentUser = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      print('User data fetched: ${currentUser?.toMap()}');
    } else {
      print('No user data found for UID: $uid');
    }
  }
  //METHOD TO UPDAT
  Future<void> updateUserData(UserModel updatedUser) async {
    print('Updating user data for ${_auth.currentUser?.email}');
    await _firestore.collection('User').doc(_auth.currentUser!.uid).update(updatedUser.toMap());
    currentUser = updatedUser;
    print('User data updated: ${currentUser?.toMap()}');
  }
}
