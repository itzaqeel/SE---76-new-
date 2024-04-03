import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/Pages/homePageFinal.dart';
import '../components/app_text_form_field.dart';
import '../utils/helpers/snackbar_helper.dart';
import '../values/app_constants.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UpdatePasswordPage(),
    );
  }
}

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<UpdatePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController oldPasswordController;
  late final TextEditingController confirmPasswordController;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final ValueNotifier<bool> oldPasswordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> confirmPasswordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    oldPasswordController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> updatePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Reauthenticate user
        final user = _auth.currentUser;
        final credential = EmailAuthProvider.credential(
          email: emailController.text,
          password: oldPasswordController.text,
        );
        await user!.reauthenticateWithCredential(credential);

        // Update password
        await user.updatePassword(passwordController.text);

        // Navigate to success screen or show success message
        // For example, navigate to the home screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePageSelector()),
        );

        // Show success snackbar
        SnackbarHelper.showSnackBar('Password updated successfully!');
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
                        "Update Password",
                        style: AppTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Update your password",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color.fromRGBO(0, 162, 142, 1),
                        ),
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
                        valueListenable: oldPasswordNotifier,
                        builder: (_, oldPasswordObscure, __) {
                          return AppTextFormField(
                            obscureText: oldPasswordObscure,
                            controller: oldPasswordController,
                            labelText: "Old Password",
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: (_) => _formKey.currentState?.validate(),
                            validator: (value) {
                              return value!.isEmpty
                                  ? "Please, Old Enter Password"
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
                                onPressed: () => oldPasswordNotifier.value =
                                    !oldPasswordObscure,
                                style: IconButton.styleFrom(
                                  minimumSize: const Size.square(48),
                                ),
                                icon: Icon(
                                  oldPasswordObscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: passwordNotifier,
                        builder: (_, passwordObscure, __) {
                          return AppTextFormField(
                            obscureText: passwordObscure,
                            controller: passwordController,
                            labelText: "New Password",
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: (_) => _formKey.currentState?.validate(),
                            validator: (value) {
                              return value!.isEmpty
                                  ? "Please, New Enter Password"
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
                            labelText: "Confirm New Password",
                            controller: confirmPasswordController,
                            obscureText: confirmPasswordObscure,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: (_) => _formKey.currentState?.validate(),
                            validator: (value) {
                              return value!.isEmpty
                                  ? "Please, Re-Enter New Password"
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
                onPressed: updatePassword,
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
                child: const Text('Update Password'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
