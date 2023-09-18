// ignore_for_file: file_names

import 'package:aone/screens/billView_screen.dart';
import 'package:aone/screens/shose_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../modules/user_modle.dart';
import '../widgets/BiscBottom_Widget.dart';
import 'addProduct_screen.dart';

// ignore: must_be_immutable
class LogInScreen extends StatefulWidget {
  LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoad = false;
  var isPasswordHidden = true;
  final _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: !isLoad
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 60,
                        left: 25,
                        right: 25,
                        bottom: 10,
                      ),
                      child: Image.asset(
                        "assets/image/logo.jpg",
                      ),
                    ),
                    Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 25),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.blueGrey[100],
                      ),

                      child: Form(
                        autovalidateMode: AutovalidateMode.always,
                        key: _formKey,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Welcome Back Text
                              Container(
                                // padding: const EdgeInsets.only(
                                //   top: 80,
                                // ),
                                child: const Text(
                                  "اهلا وسهلا",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                              // Username Input
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 10, left: 25, right: 25),
                                child: TextFormField(
                                  autofocus: false,
                                  textDirection: TextDirection.rtl,
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return ("* مطلوب");
                                    }
                                    // reg expression for email validation
                                    // if (!RegExp(
                                    //         "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    //     .hasMatch(value)) {
                                    //   return ("الرجاء ادخال صيغة Email صحيحة!");
                                    // }

                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    label: Align(
                                        alignment: Alignment.topRight,
                                        child: Text("اسم المستخدم")),
                                  ),
                                ),
                              ),

                              // Password Input
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 20, left: 25, right: 25),
                                child: TextFormField(
                                  textDirection: TextDirection.rtl,
                                  obscureText: isPasswordHidden,
                                  autofocus: false,
                                  controller: passwordController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    RegExp regex = RegExp(r'^.{6,}$');
                                    if (value!.isEmpty) {
                                      return ("* مطلوب");
                                    }
                                    if (!regex.hasMatch(value)) {
                                      return ("الحد الادنى 6 محارف");
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    // labelStyle: TextStyle(),

                                    label: const Align(
                                        alignment: Alignment.topRight,
                                        child: Text("كلمة السر")),
                                    prefixIcon: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.remove_red_eye),
                                    ),
                                    // suffixIcon: IconButton(
                                    //   onPressed: () {},
                                    //   icon: const Icon(Icons.remove_red_eye),
                                    // ),
                                  ),
                                ),
                              ),

                              // Login Now Button
                              BaiscBottomWidget(
                                onTap: () {
                                  // Navigator.pushReplacementNamed(context, "/shose");
                                  signIn(
                                      emailController.text.toString() +
                                          "@a.com",
                                      passwordController.text.toString());
                                },
                                text: 'تسجيل الدخول ',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoad = true;
      });
      await _auth
          .signInWithEmailAndPassword(
              email: email.toString(), password: password.toString())
          .then((uid) async {
        Fluttertoast.showToast(msg: "Login Successful!");

        final DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid.user?.uid)
            .get();
        UserModel u = UserModel.fromMap(snapshot.data());
        preferences.setString("uid", uid.user!.uid);
        preferences.setString('userName', u.email.toString());
        preferences.setString('userType', u.type.toString());
        preferences.setString('useradmin', u.sub_admin.toString());
        u.type.toString() == "admin"
            ? Navigator.replace(context,
                oldRoute: ModalRoute.of(context)!,
                newRoute:
                    MaterialPageRoute(builder: (context) => ShoseScreen()))
            : Navigator.replace(context,
                oldRoute: ModalRoute.of(context)!,
                newRoute: MaterialPageRoute(builder: (context) => ViewBill()));
        setState(() {
          isLoad = false;
        });
      }).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
        setState(() {
          isLoad = false;
        });
      });
    }
  }

  Future<User?> _signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!);
      return null;
    }
  }
}
