// import 'package:flutter/material.dart';
// import 'package:frontend/Pages/Navigation.dart';
// import '../components/app_text_form_field.dart';
// import '../utils/helpers/navigation_helper.dart';
// import '../utils/helpers/snackbar_helper.dart';
// import '../values/app_constants.dart';
// import '../values/app_regex.dart';
// import '../values/app_routes.dart';
// import '../values/app_strings.dart';
// import '../values/app_theme.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:frontend/Pages/service/database.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final session = Session();
//
//   final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
//   final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);
//
//   late final TextEditingController emailController;
//   late final TextEditingController passwordController;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   void initializeControllers() {
//     emailController = TextEditingController()..addListener(controllerListener);
//     passwordController = TextEditingController()
//       ..addListener(controllerListener);
//   }
//
//   void disposeControllers() {
//     emailController.dispose();
//     passwordController.dispose();
//   }
//
//   void controllerListener() {
//     final email = emailController.text;
//     final password = passwordController.text;
//
//     if (email.isEmpty && password.isEmpty) return;
//
//     if (AppRegex.emailRegex.hasMatch(email) &&
//         AppRegex.passwordRegex.hasMatch(password)) {
//       fieldValidNotifier.value = true;
//     } else {
//       fieldValidNotifier.value = false;
//     }
//   }
//
//   @override
//   void initState() {
//     initializeControllers();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     disposeControllers();
//     super.dispose();
//   }
//   Future<void> loginUser() async {
//
//     if (_formKey.currentState!.validate()) {
//       try {
//         await _auth
//             .signInWithEmailAndPassword(
//           email: emailController.text,
//           password: passwordController.text,
//         );
//         await session.loginUser(emailController.text, passwordController.text);
//
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) =>NavBar(),
//           ),
//           );
//           print('Successfully Logged in');
//
//       } catch (e) {
//         print(e);
//         SnackbarHelper.showSnackBar(e.toString());
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Image
//           Image.asset(
//             'assets/page1-bg.jpg', // Your image asset path
//             fit: BoxFit.cover,
//             width: double.infinity,
//             height: double.infinity,
//           ),
//           Positioned.fill(
//             child: Container(
//               color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
//             ),
//           ),
//
//           ListView(
//             padding: EdgeInsets.zero,
//             children: [
//               // Content overlaying the background image
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Center(
//                           child: Column(
//                             children: [
//                               // Add your image here
//                               Image.asset(
//                                 'assets/Logo-final.png', // Your image asset path
//                                 width: 500, // Adjust size as needed
//                                 height: 200,
//                               ),
//
//                               const Text(
//                                 AppStrings.login,
//                                 style: AppTheme.titleLarge,
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         const Text(
//                           AppStrings.signInToYourAccount,
//                           style: TextStyle(
//                             color: Color.fromRGBO(0, 162, 142, 1),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Form(
//                     key: _formKey,
//                     child: Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           AppTextFormField(
//                             controller: emailController,
//                             labelText: AppStrings.email,
//                             keyboardType: TextInputType.emailAddress,
//                             textInputAction: TextInputAction.next,
//                             onChanged: (_) => _formKey.currentState?.validate(),
//                             validator: (value) {
//                               return value!.isEmpty
//                                   ? AppStrings.pleaseEnterEmailAddress
//                                   : AppConstants.emailRegex.hasMatch(value)
//                                       ? null
//                                       : AppStrings.invalidEmailAddress;
//                             },
//                           ),
//                           ValueListenableBuilder(
//                             valueListenable: passwordNotifier,
//                             builder: (_, passwordObscure, __) {
//                               return AppTextFormField(
//                                 obscureText: passwordObscure,
//                                 controller: passwordController,
//                                 labelText: AppStrings.password,
//                                 textInputAction: TextInputAction.done,
//                                 keyboardType: TextInputType.visiblePassword,
//                                 onChanged: (_) =>
//                                     _formKey.currentState?.validate(),
//                                 validator: (value) {
//                                   return value!.isEmpty
//                                       ? AppStrings.pleaseEnterPassword
//                                       : AppConstants.passwordRegex
//                                               .hasMatch(value)
//                                           ? null
//                                           : AppStrings.invalidPassword;
//                                 },
//                                 suffixIcon: IconButton(
//                                   onPressed: () =>
//                                       passwordNotifier.value = !passwordObscure,
//                                   style: IconButton.styleFrom(
//                                     minimumSize: const Size.square(48),
//                                   ),
//                                   icon: Icon(
//                                     passwordObscure
//                                         ? Icons.visibility_off_outlined
//                                         : Icons.visibility_outlined,
//                                     size: 20,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                           TextButton(
//                             onPressed: () {},
//                             child: const Text(AppStrings.forgotPassword),
//                           ),
//                           const SizedBox(height: 20),
//                           ValueListenableBuilder(
//                             valueListenable: fieldValidNotifier,
//                             builder: (_, isValid, __) {
//                               return FilledButton(
//                                 onPressed: isValid
//                                     ? loginUser : null,
//                                 child: const Text(AppStrings.login),
//                               );
//                             },
//                           ),
//                           const SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         AppStrings.doNotHaveAnAccount,
//                         style: AppTheme.bodySmall,
//                       ),
//                       const SizedBox(width: 4),
//                       TextButton(
//                         onPressed: () => NavigationHelper.pushReplacementNamed(
//                           AppRoutes.register,
//                         ),  P[
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
// }

import 'package:flutter/material.dart';
import 'package:frontend/Pages/Navigation.dart';
import '../components/app_text_form_field.dart';
import '../utils/helpers/navigation_helper.dart';
import '../utils/helpers/snackbar_helper.dart';
import '../values/app_constants.dart';
import '../values/app_regex.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/Pages/service/database.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final session = Session();

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void initializeControllers() {
    emailController = TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }

  void controllerListener() {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty && password.isEmpty) return;

    if (AppRegex.emailRegex.hasMatch(email) &&
        AppRegex.passwordRegex.hasMatch(password)) {
      fieldValidNotifier.value = true;
    } else {
      fieldValidNotifier.value = false;
    }
  }

  @override
  void initState() {
    initializeControllers();
    super.initState();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  Future<void> loginUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        await session.loginUser(emailController.text, passwordController.text);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavBar()),
        );
        print('Successfully Logged in');
      } catch (e) {
        print(e);
        SnackbarHelper.showSnackBar(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/page1-bg.jpg', // Your image asset path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
            ),
          ),

          ListView(
            padding: EdgeInsets.zero,
            children: [
              // Content overlaying the background image
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              // Add your image here
                              Image.asset(
                                'assets/Logo-final.png', // Your image asset path
                                width: 500, // Adjust size as needed
                                height: 200,
                              ),

                              const Text(
                                AppStrings.login,
                                style: AppTheme.titleLarge,
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              const Text(
                                AppStrings.signInToYourAccount,
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 162, 142, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppTextFormField(
                            controller: emailController,
                            labelText: AppStrings.email,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onChanged: (_) => _formKey.currentState?.validate(),
                            validator: (value) {
                              return value!.isEmpty
                                  ? AppStrings.pleaseEnterEmailAddress
                                  : AppConstants.emailRegex.hasMatch(value)
                                  ? null
                                  : AppStrings.invalidEmailAddress;
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: passwordNotifier,
                            builder: (_, passwordObscure, __) {
                              return AppTextFormField(
                                obscureText: passwordObscure,
                                controller: passwordController,
                                labelText: AppStrings.password,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.visiblePassword,
                                onChanged: (_) =>
                                    _formKey.currentState?.validate(),
                                validator: (value) {
                                  return value!.isEmpty
                                      ? AppStrings.pleaseEnterPassword
                                      : AppConstants.passwordRegex
                                      .hasMatch(value)
                                      ? null
                                      : AppStrings.invalidPassword;
                                },
                                suffixIcon: IconButton(
                                  onPressed: () =>
                                  passwordNotifier.value = !passwordObscure,
                                  style: IconButton.styleFrom(
                                    minimumSize: const Size.square(48),
                                  ),
                                  icon: Icon(
                                    passwordObscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          ValueListenableBuilder(
                            valueListenable: fieldValidNotifier,
                            builder: (_, isValid, __) {
                              return FilledButton(
                                onPressed: isValid ? loginUser : null,
                                child: const Text(AppStrings.login),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        AppStrings.doNotHaveAnAccount,
                        style: AppTheme.bodySmall,
                      ),
                      const SizedBox(width: 4),
                      TextButton(
                        onPressed: () => NavigationHelper.pushReplacementNamed(
                          AppRoutes.register,
                        ),
                        child: const Text(AppStrings.signUp),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}