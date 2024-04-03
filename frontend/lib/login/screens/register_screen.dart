import 'package:flutter/material.dart';
import 'package:frontend/Pages/Navigation.dart';
import '../../Pages/service/database.dart';
import '../components/app_text_form_field.dart';
import '../utils/helpers/snackbar_helper.dart';
import '../values/app_constants.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> confirmPasswordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void controllerListener() {
    final email = emailController.text;
    final oldPassword = passwordController.text;
    final newPassword = passwordController.text;
    final confirmNewPassword = passwordController.text;

    // if (email.isEmpty && oldPassword.isEmpty && newPassword.isEmpty && confirmNewPassword.isEmpty) return;

    if (email.isNotEmpty &&
        oldPassword.isNotEmpty &&
        newPassword.isNotEmpty &&
        confirmNewPassword.isNotEmpty) {
      fieldValidNotifier.value = true;
    } else {
      fieldValidNotifier.value = false;
    }
  }

  void addDetailsDB() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      Map<String, dynamic> userMap = {
        "Name": nameController.text,
        "Level": 1,
        "XP": 0,
        "HP": 100,
        "Avatar": 5,
        "Character": 0,
        "Email": emailController.text,
        "Nutrition": 1,
        "Password": passwordController
            .text, // Note: Storing password in plaintext is not recommended for security reasons
        "Accessory": 1,
      };
      await DatabaseMethods().addUserData(userMap, uid);
    }
  }

  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        )
            .then((value) {
          print('Successfully Created User Account');
        });
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
              Image.asset(
                'assets/page1-bg.jpg', // Your image asset path
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              // Background Image
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
                ),
              ),
              ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/Logo-final.png', // Your image asset path
                            width: 500, // Adjust size as needed
                            height: 150,
                          ),
                          const Text(
                            AppStrings.signUp,
                            style: AppTheme.titleLarge,
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            AppStrings.createYourAccount,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color.fromRGBO(0, 162, 142, 1),
                            ),
                          ),

                          // Your form fields
                          AppTextFormField(
                            autofocus: true,
                            labelText: AppStrings.name,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) => _formKey.currentState?.validate(),
                            validator: (value) {
                              return value!.isEmpty
                                  ? AppStrings.pleaseEnterName
                                  : value.length < 4
                                  ? AppStrings.invalidName
                                  : null;
                            },
                            controller: nameController,
                          ),
                          AppTextFormField(
                            labelText: AppStrings.email,
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (_) => _formKey.currentState?.validate(),
                            validator: (value) {
                              return value!.isEmpty
                                  ? AppStrings.pleaseEnterEmailAddress
                                  : AppConstants.emailRegex.hasMatch(value)
                                  ? null
                                  : AppStrings.invalidEmailAddress;
                            },
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: passwordNotifier,
                            builder: (_, passwordObscure, __) {
                              return AppTextFormField(
                                obscureText: passwordObscure,
                                controller: passwordController,
                                labelText: AppStrings.password,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.visiblePassword,
                                onChanged: (_) => _formKey.currentState?.validate(),
                                validator: (value) {
                                  return value!.isEmpty
                                      ? AppStrings.pleaseEnterPassword
                                      : AppConstants.passwordRegex.hasMatch(value)
                                      ? null
                                      : AppStrings.invalidPassword;
                                },
                                suffixIcon: Focus(
                                  /// If false,
                                  ///
                                  /// disable focus for all of this node's descendants
                                  descendantsAreFocusable: false,

                                  /// If false,
                                  ///
                                  /// make this widget's descendants un-traversable.
                                  // descendantsAreTraversable: false,
                                  child: IconButton(
                                    onPressed: () =>
                                    passwordNotifier.value = !passwordObscure,
                                    style: IconButton.styleFrom(
                                      minimumSize: const Size.square(48),
                                    ),
                                    icon: Icon(
                                      passwordObscure
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: confirmPasswordNotifier,
                            builder: (_, confirmPasswordObscure, __) {
                              return AppTextFormField(
                                labelText: AppStrings.confirmPassword,
                                controller: confirmPasswordController,
                                obscureText: confirmPasswordObscure,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.visiblePassword,
                                onChanged: (_) => _formKey.currentState?.validate(),
                                validator: (value) {
                                  return value!.isEmpty
                                      ? AppStrings.pleaseReEnterPassword
                                      : AppConstants.passwordRegex.hasMatch(value)
                                      ? passwordController.text ==
                                      confirmPasswordController.text
                                      ? null
                                      : AppStrings.passwordNotMatched
                                      : AppStrings.invalidPassword;
                                },
                                suffixIcon: Focus(
                                  /// If false,
                                  ///
                                  /// disable focus for all of this node's descendants.
                                  descendantsAreFocusable: false,

                                  /// If false,
                                  ///
                                  /// make this widget's descendants un-traversable.
                                  // descendantsAreTraversable: false,
                                  child: IconButton(
                                    onPressed: () => confirmPasswordNotifier.value =
                                    !confirmPasswordObscure,
                                    style: IconButton.styleFrom(
                                      minimumSize: const Size.square(48),
                                    ),
                                    icon: Icon(
                                      confirmPasswordObscure
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.white,
                                      // ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        controllerListener();
                        if (fieldValidNotifier.value) {
                          await registerUser(); // Wait for user registration to complete
                          addDetailsDB(); // Add user details to the database
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NavBar()),
                          );
                        } else
                          (SnackbarHelper.showSnackBar("Enter detailGGGGs to Sign in"));
                      } catch (e) {
                        // Handle registration errors
                        print(e);
                        SnackbarHelper.showSnackBar(e.toString());
                      }
                    },
                    style: FilledButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(0, 162, 142, 1),
                      disabledBackgroundColor: Colors.grey.shade300,
                      minimumSize: const Size(double.infinity, 52),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
            ),
        );
    }
}
