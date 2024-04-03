import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_register_app.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAqIoHa7_eJ4tpwhxCvf-8CjKUOPJXnFOU",
      appId: "1:1050763890011:android:f5239f6410778886949e7e",
      messagingSenderId: "1:1050763890011:android:f5239f6410778886949e7e",
      projectId: "ecoquestfirebase",
    ),
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
        (_) => runApp(const LoginRegisterApp()),
  );
}
