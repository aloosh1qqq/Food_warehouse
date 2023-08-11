// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_state_button/progress_button.dart';

import '../main.dart';
import '../modules/user_modle.dart';
import '../test.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _auth = FirebaseAuth.instance;
  ButtonState stateTextWithIcon = ButtonState.idle;
  final _formKey = GlobalKey<FormState>();
  var isPasswordHidden = true;
  var isConPasswordHidden = true;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final conPasswordController = TextEditingController();
  final emailController = TextEditingController();

  String? pass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        right: false,
        left: false,
        bottom: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
                top: 0, bottom: -300, right: 0, left: 0, child: Container()),
            SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Welcome Back Text
                        Container(
                          padding: const EdgeInsets.only(
                            top: 80,
                          ),
                          child: const Text(
                            "Create an Account",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),

                        // Username Input
                        Container(
                          margin: const EdgeInsets.only(
                              top: 50, left: 25, right: 25),
                          child: TextFormField(
                            controller: usernameController,
                            validator: (value) {
                              RegExp regex = RegExp(r'^.{3,}$');

                              if (value!.isEmpty) {
                                return '* Required';
                              }
                              if (!regex.hasMatch(value)) {
                                return "Minimum 3 character";
                              }
                              return null;
                            },
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            decoration:
                                const InputDecoration(label: Text("Username")),
                          ),
                        ),

                        // Email Input
                        Container(
                          margin: const EdgeInsets.only(
                              top: 20, left: 25, right: 25),
                          child: TextFormField(
                            autofocus: true,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("* required");
                              }
                              // reg expression for email validation
                              // if (!RegExp(
                              //         "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              //     .hasMatch(value)) {
                              //   return ("Please enter a valid email!");
                              // }

                              return null;
                            },
                            decoration:
                                const InputDecoration(label: Text("Email")),
                          ),
                        ),

                        // Password Input
                        Container(
                          margin: const EdgeInsets.only(
                              top: 20, left: 25, right: 25),
                          child: TextFormField(
                            obscureText: isPasswordHidden,
                            autofocus: true,
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              RegExp regex = RegExp(r'^.{6,}$');
                              pass = value;
                              if (value!.isEmpty) {
                                return ("* required");
                              }
                              if (!regex.hasMatch(value)) {
                                return ("Minimum 6 characters!");
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: Text("Password"),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  isPasswordHidden = !isPasswordHidden;
                                  setState(() {});
                                },
                                icon: const Icon(Icons.remove_red_eye),
                              ),
                            ),
                          ),
                        ),

                        // Confirm Password Input
                        Container(
                          margin: const EdgeInsets.only(
                              top: 20, left: 25, right: 25),
                          child: TextFormField(
                            obscureText: isConPasswordHidden,
                            autofocus: true,
                            controller: conPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '* Required';
                              }
                              if (value != pass) {
                                return "Both password are not matching!";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: Text("Confirm Password"),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  isConPasswordHidden = !isConPasswordHidden;
                                  setState(() {});
                                },
                                icon: const Icon(Icons.remove_red_eye),
                              ),
                            ),
                          ),
                        ),

                        // Sign up Button
                        Container(
                          width: 200,
                          height: 40,
                          margin: const EdgeInsets.only(top: 50),
                          child: MyCustomWidget(
                            icon: Icons.send,
                            text: "Sign up",
                            stateTextWithIcon: stateTextWithIcon,
                            ontap: () async {
                              await signUp(emailController.text.toString(),
                                  passwordController.text.toString());
                            },
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(top: 100),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account?"),
                              TextButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             const LoginPage()));
                                  },
                                  child: const Text(
                                    "Login",
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        stateTextWithIcon = ButtonState.loading;
      });
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                postDetailsToFirestore(),
                Future.delayed(
                  Duration(seconds: 1),
                  () {
                    setState(
                      () {
                        stateTextWithIcon = ButtonState.success;
                      },
                    );
                  },
                ),
                Future.delayed(
                  Duration(seconds: 2),
                  () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => Main_screen()));
                  },
                ),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
        setState(() {
          stateTextWithIcon = ButtonState.fail;
          Future.delayed(
            Duration(seconds: 2),
            () {
              setState(
                () {
                  stateTextWithIcon = ButtonState.idle;
                },
              );
            },
          );
        });
      });

      return true;
    }
    return false;
  }

  postDetailsToFirestore() async {
    // Calling our firestore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    // Calling usermodel
    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.username = usernameController.text;
    userModel.type = "admin";
    // sending our values
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    UserModel u = UserModel.fromMap(snapshot.data());
    preferences.setString('userName', u.email.toString());
    preferences.setString('userType', u.type.toString());

    Fluttertoast.showToast(msg: "Account Created Successfully ;)");

    // Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => true);
  }
}
