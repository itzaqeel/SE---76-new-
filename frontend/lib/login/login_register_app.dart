
import 'package:flutter/material.dart';

import '../Pages/splash.dart';
import 'routes.dart';
import 'utils/helpers/navigation_helper.dart';
import 'utils/helpers/snackbar_helper.dart';
import 'values/app_routes.dart';
import 'values/app_strings.dart';
import 'values/app_theme.dart';

class LoginRegisterApp extends StatefulWidget {
  const LoginRegisterApp({Key? key}) : super(key: key);

  @override
  _LoginRegisterAppState createState() => _LoginRegisterAppState();
}

class _LoginRegisterAppState extends State<LoginRegisterApp> {
  bool _isSplashScreenVisible = true;

  @override
  void initState() {
    super.initState();
    // Start the splash screen timer
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isSplashScreenVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSplashScreenVisible) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splash(),
      );
    } else {
      // Return the main content of your app here
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.loginAndRegister,
        theme: AppTheme.themeData,
        initialRoute: AppRoutes.login,
        scaffoldMessengerKey: SnackbarHelper.key,
        navigatorKey: NavigationHelper.key,
        onGenerateRoute: Routes.generateRoute,
      );
    }
  }
}
