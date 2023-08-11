import 'package:aone/screens/avtiveCode_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';

class ClinetScreen extends StatefulWidget {
  const ClinetScreen({super.key});

  @override
  State<ClinetScreen> createState() => _ClinetScreenState();
}

class _ClinetScreenState extends State<ClinetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "المندوبين",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.logout_outlined),
          onPressed: () {
            print("object");
            Navigator.pop(
              context,
            );
          },
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final prod = snapshot.data?.docs.toList();

                  return ListView.builder(
                      itemCount: prod!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(15),
                          height: 250,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 59, 67, 71),
                              borderRadius: BorderRadius.circular(25)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "اسم المستخدم : ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blueAccent),
                                      ),
                                      Text(
                                        prod[index]["email"].toString(),
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "عنوان المستخدم : ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blueAccent),
                                      ),
                                      Text(
                                        prod[index]["address"].toString(),
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "رقم الهاتف : ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blueAccent),
                                      ),
                                      Text(
                                        prod[index]["phone"].toString(),
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "الرقم التسلسلي : ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blueAccent),
                                      ),
                                      Text(
                                        prod[index]["uid"].toString(),
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "نوع المستخدم : ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blueAccent),
                                      ),
                                      Text(
                                        prod[index]["type"].toString(),
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('تأكيد الحذف'),
                                              content: const Text(
                                                  'هل أنت متأكد من رغبتك في حذف هذا المستخدم؟'),
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
                                                        .collection('users')
                                                        .doc(prod[index]["uid"])
                                                        .delete()
                                                        .then((value) {
                                                      Fluttertoast.showToast(
                                                          msg: "تم حذف المنتج");
                                                      Navigator.of(context)
                                                          .pop(); // إغلاق حوار التأكيد
                                                      // يمكنك أيضًا إظهار رسالة تأكيد الحذف هنا
                                                    }).catchError((error) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "$error تم حذف المنتج");

                                                      Navigator.of(context)
                                                          .pop(); // إغلاق حوار التأكيد
                                                      // يمكنك أيضًا إظهار رسالة خطأ هنا
                                                    });
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ))
                                ],
                              ),

                              // FirebaseFirestore.instance
                              //                                     .collection('users')
                              //                                     .doc(prod[index]["uid"])
                              //                                     .delete()
                              //                                     .then((value) {
                              //                                   Fluttertoast.showToast(
                              //                                       msg: "تم حذف المنتج");
                              //                                 }).catchError((error) {
                              //                                   Fluttertoast.showToast(
                              //                                       msg: "لم يتم الحذف");
                              //                                 });
                              // const SizedBox(
                              //   width: 15,
                              // ),
                              // Container(
                              //   padding:
                              //       const EdgeInsets.symmetric(horizontal: 20),
                              //   margin: const EdgeInsets.only(right: 5),
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(25),
                              //       color:
                              //           const Color.fromARGB(255, 28, 35, 39)),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.center,
                              //     children: [
                              //       Text(
                              //         prod[index]["qrScan"].toString(),
                              //         style: const TextStyle(
                              //             fontSize: 14, color: Colors.white),
                              //       ),
                              //       Text(
                              //         prod[index]["qrTime"].toString(),
                              //         style: const TextStyle(
                              //             fontSize: 14, color: Colors.white),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        );
                      });
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}
