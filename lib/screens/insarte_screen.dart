import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../modules/user_modle.dart';
import '../widgets/BiscBottom_Widget.dart';
import '../widgets/textField_Wdiget.dart';

class InsertScreen extends StatefulWidget {
  InsertScreen({super.key});

  @override
  State<InsertScreen> createState() => _InsertScreenState();
}

class _InsertScreenState extends State<InsertScreen> {
  final _auth = FirebaseAuth.instance;
  final phoneContorller = TextEditingController();
  final passwordController = TextEditingController();
  final addresController = TextEditingController();
  final emailController = TextEditingController();
  bool isLoad = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text("تسجيل مستخدم"),
      ),
      body: !isLoad
          ? Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFieldWidget(
                    controller: emailController,
                    hint: 'اسم المندوب ',
                  ),
                  TextFieldWidget(
                    controller: passwordController,
                    hint: 'كلمة المرور',
                    obscureText: true,
                  ),
                  TextFieldWidget(
                    type: TextInputType.phone,
                    controller: phoneContorller,
                    hint: 'رقم الهاتف',
                  ),
                  TextFieldWidget(
                    controller: addresController,
                    hint: 'العنوان',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Flexible(
                      child: BaiscBottomWidget(
                          text: "تسجيل",
                          onTap: () async {
                            if (emailController.text.isNotEmpty &
                                passwordController.text.isNotEmpty &
                                phoneContorller.text.isNotEmpty &
                                addresController.text.isNotEmpty) {
                              await signUp(
                                  emailController.text.toString() + "@a.com",
                                  passwordController.text.toString());
                            } else {
                              Fluttertoast.showToast(
                                  msg: "يجب تعبئة كل الحقول ");
                            }
                          }))
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Future signUp(String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => {
              // Fluttertoast.showToast(msg: "Account Created Successfully "),
              postDetailsToFirestore(),
            })
        .catchError((e) {
      Fluttertoast.showToast(msg: e!.message);
    });

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

    userModel.type = "user";
    userModel.address = addresController.text;
    userModel.phone = phoneContorller.text;
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
    print(u);
    phoneContorller.clear();
    addresController.clear();
    emailController.clear();
    passwordController.clear();
    Fluttertoast.showToast(msg: "Account Created Successfully ");

    // Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => true);
  }
}





// Flexible(
                //   child: BaiscBottomWidget(
                //     onTap: () {
                //       Navigator.pushNamed(context, "/qrscan");
                //     },
                //     text: "QR مسح",
                //   ),
                // ),