import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../widgets/BiscBottom_Widget.dart';
import 'avtiveCode_screen.dart';

class ShoseScreen extends StatelessWidget {
  const ShoseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    Future<void> logOut() async {
      try {
        await _auth.signOut();
        // User successfully logged out
      } catch (e) {
        // An error occurred while logging out
        print('Error: $e');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "واجهة المدير",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.logout_outlined),
          onPressed: () {
            logOut();
            preferences.clear();
            Navigator.replace(context,
                oldRoute: ModalRoute.of(context)!,
                newRoute: MaterialPageRoute(
                    builder: (context) => const ActiveCode()));
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/image/logo.jpg"),
          // const Text(
          //   "واجهة المدير",
          //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          // ),
          const SizedBox(
            height: 25,
          ),
          Row(
            children: [
              Flexible(
                  child: Column(
                children: [
                  BaiscBottomWidget(
                      text: "تسجيل",
                      onTap: () {
                        Navigator.pushNamed(context, '/insert');
                      }),
                  BaiscBottomWidget(
                      text: "مسح البيانات",
                      onTap: () {
                        print("object");
                        // Navigator.pushNamed(context, '/insert');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('تأكيد الحذف'),
                              content:
                                  const Text('هل أنت متأكد من رغبتك في الحذف؟'),
                              actions: [
                                TextButton(
                                  child: const Text('إلغاء'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // إغلاق حوار التأكيد
                                  },
                                ),
                                IconButton(
                                  icon: const Text('حذف'),
                                  onPressed: () {
                                    // قم بحذف المستند من Firestore
                                    FirebaseFirestore.instance
                                        .collection('product')
                                        .get()
                                        .then((snapshot) {
                                      for (DocumentSnapshot doc
                                          in snapshot.docs) {
                                        doc.reference.delete();
                                      }
                                      Fluttertoast.showToast(
                                          msg: 'تم حذف المجموعة بنجاح');
                                    }).catchError((error) {
                                      Fluttertoast.showToast(
                                          msg:
                                              'حدث خطأ أثناء حذف المجموعة: $error');
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }),
                ],
              )),
              Flexible(
                  child: Column(
                children: [
                  BaiscBottomWidget(
                      text: "المنتجات",
                      onTap: () {
                        Navigator.pushNamed(context, "/viewProduct");
                      }),
                  BaiscBottomWidget(
                      text: "المندوبين",
                      onTap: () {
                        Navigator.pushNamed(context, "/clinet");
                      }),
                ],
              )),
            ],
          ),
          Flexible(
            child: BaiscBottomWidget(
                text: "الطلبيات",
                onTap: () {
                  Navigator.pushNamed(context, "/viewBill");
                }),
          )
        ],
      ),
    );
  }
}
// FirebaseFirestore.instance
//                                     .collection('product')
//                                     .get()
//                                     .then((snapshot) {
//                                   for (DocumentSnapshot doc in snapshot.docs) {
//                                     doc.reference.delete();
//                                   }
//                                   Fluttertoast.showToast(
//                                       msg: 'تم حذف المجموعة بنجاح');
//                                 }).catchError((error) {
//                                   Fluttertoast.showToast(
//                                       msg:
//                                           'حدث خطأ أثناء حذف المجموعة: $error');
//                                 });