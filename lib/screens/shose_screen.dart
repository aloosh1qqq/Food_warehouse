import 'dart:io';

import 'package:aone/screens/logIn_screen.dart';
import 'package:aone/widgets/textField_Wdiget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';
import '../modules/image.dart';
import '../pick_image.dart';
import '../widgets/BiscBottom_Widget.dart';
import '../widgets/carouser_slider.dart';
import 'avtiveCode_screen.dart';

enum _menuValue {
  p1,
  p2,
  p3,
  p4,
  p5,
  p6,
  p7,
}

class ShoseScreen extends StatefulWidget {
  const ShoseScreen({super.key});

  @override
  State<ShoseScreen> createState() => _ShoseScreenState();
}

class _ShoseScreenState extends State<ShoseScreen> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final contorller = TextEditingController();
    String imageUrl = '';
    List<String> imgList = [];
    Future<void> logOut() async {
      try {
        await _auth.signOut();
        // User successfully logged out
      } catch (e) {
        // An error occurred while logging out
        print('Error: $e');
      }
    }

    File? imageFile;

    void selectImages() async {
      var res = await pickImages();
      setState(() {
        imageFile = res;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          " الواجهة الرئيسية",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        // leading: IconButton(
        //   icon: const Icon(Icons.logout_outlined),
        //   onPressed: () {
        //     logOut();
        //     preferences.remove("userType");
        //     Navigator.replace(context,
        //         oldRoute: ModalRoute.of(context)!,
        //         newRoute:
        //             MaterialPageRoute(builder: (context) => LogInScreen()));
        //   },
        // ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            PopupMenuButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.blueAccent,
                size: 30,
              ),
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<_menuValue>(
                  value: _menuValue.p1,
                  child: Center(child: Text(' تسجيل مندوب')),
                ),
                const PopupMenuItem(
                    value: _menuValue.p2,
                    child: Center(child: Text('المنتجات'))),
                const PopupMenuItem(
                    value: _menuValue.p3,
                    child: Center(child: Text('الطلبيات'))),
                const PopupMenuItem(
                    value: _menuValue.p4,
                    child: Center(child: Text('المندوبين'))),
                const PopupMenuItem(
                    value: _menuValue.p5,
                    child: Center(child: Text('مسح البيانات'))),
                const PopupMenuItem(
                  value: _menuValue.p6,
                  child: Center(child: Text('حول الشركة')),
                ),
                const PopupMenuItem(
                  value: _menuValue.p7,
                  child: Center(child: Text('تسجيل الخروج')),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case _menuValue.p1:
                    if (preferences.get("userType") == 'مدير' ||
                        preferences.get("userType") == 'admin') {
                      Navigator.pushNamed(context, '/insert');
                    } else {
                      Fluttertoast.showToast(msg: 'الخدمة متاحة للمدير فقط');
                    }
                    break;
                  case _menuValue.p2:
                    Navigator.pushNamed(context, "/viewProduct");
                    break;
                  case _menuValue.p3:
                    Navigator.pushNamed(context, "/viewBill");
                    break;
                  case _menuValue.p4:
                    if (preferences.get("userType") == 'مدير' ||
                        preferences.get("userType") == 'admin') {
                      Navigator.pushNamed(context, "/clinet");
                    } else {
                      Fluttertoast.showToast(msg: 'الخدمة متاحة للمدير فقط');
                    }
                    break;
                  case _menuValue.p7:
                    logOut();
                    preferences.remove("userType");
                    Navigator.replace(context,
                        oldRoute: ModalRoute.of(context)!,
                        newRoute: MaterialPageRoute(
                            builder: (context) => LogInScreen()));
                    break;
                  case _menuValue.p5:
                    if (preferences.get("userType") == 'مدير' ||
                        preferences.get("userType") == 'admin') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('تأكيد الحذف'),
                            content: Container(
                              height: 90,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('هل أنت متأكد من رغبتك في الحذف؟'),
                                  TextFieldWidget(
                                      hint: "رمز التأكيد",
                                      controller: contorller)
                                ],
                              ),
                            ),
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
                                  if (contorller.text == "0000") {
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
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'يرجى ادخال رمز صحيح');
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      Fluttertoast.showToast(msg: 'الخدمة متاحة للمدير فقط');
                    }
                    break;
                  case _menuValue.p6:
                    Navigator.pushNamed(context, "/about");
                    break;
                }
              },
            ),
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("image").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final caty = snapshot.data?.docs.toList();
                    imgList = [];
                    for (int i = 0; i < caty!.length; i++) {
                      imgList.add(caty[i]['url']);
                    }
                    return Column(
                      children: [
                        CarouselWithDotsPage(imgList: imgList),
                        // SizedBox(
                        //     height: MediaQuery.of(context).size.height * 0.02),
                        if (preferences.get("userType") == 'مدير')
                          IconButton(
                              onPressed: () async {
                                ImagePicker imagePicker = ImagePicker();
                                XFile? file = await imagePicker.pickImage(
                                    source: ImageSource.gallery);

                                if (file == null) return;

                                String uniqueFileName = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();

                                Reference referenceRoot =
                                    FirebaseStorage.instance.ref();
                                Reference referenceDirImages =
                                    referenceRoot.child('image');

                                Reference referenceImageToUpload =
                                    referenceDirImages.child(uniqueFileName);

                                try {
                                  await referenceImageToUpload
                                      .putFile(File(file.path));
                                  //Success: get the download URL
                                  imageUrl = await referenceImageToUpload
                                      .getDownloadURL();
                                  ImageModle a = ImageModle(url: imageUrl);

                                  var collection = FirebaseFirestore.instance
                                      .collection("image");
                                  collection.add(a.toJson());
                                  imgList = [];
                                } catch (error) {
                                  //Some error occurred
                                }
                              },
                              icon: Icon(Icons.add_a_photo))
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            Container(
              margin: const EdgeInsets.only(
                top: 40,
              ),
              child: Image.asset(
                "assets/image/Q.png",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
