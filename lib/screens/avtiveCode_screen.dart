import 'package:aone/main.dart';
import 'package:aone/screens/addProduct_screen.dart';
import 'package:aone/screens/shose_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/BiscBottom_Widget.dart';
import '../widgets/textField_Wdiget.dart';

class ActiveCode extends StatelessWidget {
  const ActiveCode({super.key});

  @override
  Widget build(BuildContext context) {
    final activCodeContorller = TextEditingController();

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("رمز التفعيل "),
            TextFieldWidget(
              controller: activCodeContorller,
              hint: 'ادخل رمز التفعيل',
            ),
            BaiscBottomWidget(
              onTap: () {
                if (activCodeContorller.text == "complex") {
                  preferences.setString("active", "value");
                  preferences.getString("userType") == null
                      ? Navigator.pushNamed(context, '/login')
                      : preferences.getString("userType") == "admin"
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ShoseScreen()))
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddProductScreen()));
                } else {
                  Fluttertoast.showToast(msg: "الرمز خاطئ ");
                }
              },
              text: "دخول",
            ),
          ],
        ),
      ),
    );
  }
}
