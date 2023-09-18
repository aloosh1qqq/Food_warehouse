import 'package:aone/main.dart';
import 'package:aone/screens/About.dart';
import 'package:aone/screens/logIn_screen.dart';
import 'package:aone/widgets/textField_Wdiget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data.dart';
import 'avtiveCode_screen.dart';

class ViewBill extends StatefulWidget {
  const ViewBill({super.key});

  @override
  State<ViewBill> createState() => _ViewBillState();
}

class _ViewBillState extends State<ViewBill> {
  String date = "اختر حسب التاريخ";
  late TextEditingController _priceControler;
  void initState() {
    // TODO: implement initState
    super.initState();

    _priceControler = TextEditingController();
  }

  Future<String?> openDialog(
    String id,
    String pay,
    String pay1,
    String pay2,
    String pay3,
  ) =>
      showDialog(
        context: context,
        builder: (builder) => AlertDialog(
          title: const Center(child: Text("اضافة دفعة")),
          content: SizedBox(
            height: 75,
            child: Column(
              children: [
                TextFieldWidget(
                  controller: _priceControler,
                  hint: 'قيمة الدفعة',
                  type: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    final CollectionReference productsRef =
                        FirebaseFirestore.instance.collection('bill');
                    if (pay == "0") {
                      await productsRef
                          .doc(id)
                          .update({'pay': _priceControler.text}).then((value) {
                        _priceControler.clear();
                        Fluttertoast.showToast(msg: "تمت اضافة الدفعة");
                        Navigator.pop(context);
                      });
                    } else if (pay1 == "0") {
                      await productsRef
                          .doc(id)
                          .update({'pay1': _priceControler.text}).then((value) {
                        _priceControler.clear();
                        Fluttertoast.showToast(msg: "تمت اضافة الدفعة");
                        Navigator.pop(context);
                      });
                    } else if (pay2 == "0") {
                      await productsRef
                          .doc(id)
                          .update({'pay2': _priceControler.text}).then((value) {
                        _priceControler.clear();
                        Fluttertoast.showToast(msg: "تمت اضافة الدفعة");
                        Navigator.pop(context);
                      });
                    } else if (pay3 == "0") {
                      await productsRef
                          .doc(id)
                          .update({'pay3': _priceControler.text}).then((value) {
                        _priceControler.clear();
                        Fluttertoast.showToast(
                            msg: " تمت اضافة الدفعة الاخيرة");
                        Navigator.pop(context);
                      });
                    } else {
                      Fluttertoast.showToast(msg: "تم تجاوز عدد الدفعات");
                      _priceControler.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("تعديل"),
                  // stateTextWithIcon: stateTextWithIcon,
                ),
                TextButton(
                  onPressed: () {
                    _priceControler.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("رجوع"),
                ),
              ],
            ),
          ],
        ),
      );
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    Future<void> logOut() async {
      try {
        await _auth.signOut();
        // User successfully logged out
      } catch (e) {
        // An error occurred while logging out
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        actions: [
          preferences.getString("userType") == "user"
              ? IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    Navigator.pushNamed(context, "/about");
                  })
              : Container(),
          preferences.getString("userType") == "user"
              ? IconButton(
                  icon: const Icon(Icons.logout_sharp),
                  onPressed: () {
                    logOut();
                    preferences.remove("userType");
                    Navigator.replace(context,
                        oldRoute: ModalRoute.of(context)!,
                        newRoute: MaterialPageRoute(
                            builder: (context) => LogInScreen()));
                  },
                )
              : Container()
        ],
        title: const Text(
          "الطلبيات",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot>(
              stream: date == "اختر حسب التاريخ"
                  ? FirebaseFirestore.instance
                      .collection("bill")
                      .orderBy('qrTime', descending: true)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection("bill")
                      // .orderBy('qrTime', descending: true)
                      .where('qrdate', isEqualTo: date)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final prod = snapshot.data?.docs.toList();

                  return Column(
                    children: [
                      Flexible(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('bill')
                                .where('user',
                                    isEqualTo:
                                        preferences.getString("userName"))
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<DropdownMenuItem> clientItem = [];
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              } else {
                                final clients =
                                    snapshot.data?.docs.reversed.toList();
                                for (var client in clients!) {
                                  clientItem.add(DropdownMenuItem(
                                    value: client,
                                    child: Text(client['qrdate']),
                                  ));
                                }
                                return DropdownButton(
                                    alignment: Alignment.center,
                                    hint: Text(
                                      date,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    isExpanded: true,
                                    items: clientItem,
                                    onChanged: (v) {
                                      setState(() {
                                        date = v['qrdate'];
                                      });
                                    });
                              }
                            }),
                      ),
                      Flexible(
                        flex: 10,
                        child: ListView.builder(
                            itemCount: prod!.length,
                            itemBuilder: (context, index) {
                              int total = int.parse(prod[index]["price"]) *
                                  int.parse(prod[index]["quantity"]);
                              int end = total -
                                  (int.parse(prod[index]["pay"]) +
                                      int.parse(prod[index]["pay3"]) +
                                      int.parse(prod[index]["pay1"]) +
                                      int.parse(prod[index]["pay2"]));
                              return GestureDetector(
                                onLongPress: () async {
                                  openDialog(
                                    prod[index].id,
                                    prod[index]["pay"],
                                    prod[index]["pay1"],
                                    prod[index]["pay2"],
                                    prod[index]["pay3"],
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.all(15),
                                  height: 350,
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 59, 67, 71),
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                "اسم المنتج : ",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.blueAccent),
                                              ),
                                              Text(
                                                prod[index]["name"],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          // const SizedBox(
                                          //   height: 15,
                                          // ),
                                          Row(
                                            children: [
                                              const Text(
                                                "الكمية : ",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.blueAccent),
                                              ),
                                              Text(
                                                prod[index]["quantity"],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          // const SizedBox(
                                          //   height: 15,
                                          // ),
                                          Row(
                                            children: [
                                              const Text(
                                                "السعر : ",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.blueAccent),
                                              ),
                                              Text(
                                                prod[index]["price"],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                              const Text(
                                                " ل.س ",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.redAccent),
                                              ),
                                            ],
                                          ),
                                          // const SizedBox(
                                          //   height: 15,
                                          // ),
                                          const Text(
                                            "الاجمالي",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                          // const SizedBox(
                                          //   height: 10,
                                          // ),
                                          Row(
                                            children: [
                                              Text(
                                                total.toString(),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                              const Text(
                                                " ل.س ",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.redAccent),
                                              ),
                                            ],
                                          ),
                                          // const SizedBox(
                                          //   height: 15,
                                          // ),
                                          const Text(
                                            "الدفعات",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                          // const SizedBox(
                                          //   height: 10,
                                          // ),
                                          Row(
                                            children: [
                                              Text(
                                                prod[index]["pay"],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                              const Text(
                                                " ل.س ",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.redAccent),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                prod[index]["pay1"],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                              const Text(
                                                " ل.س ",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.redAccent),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                prod[index]["pay2"],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                              const Text(
                                                " ل.س ",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.redAccent),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                prod[index]["pay3"],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                              const Text(
                                                " ل.س ",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.redAccent),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const Text(
                                            "الباقي",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                end.toString(),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                              const Text(
                                                " ل.س ",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.redAccent),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      // const SizedBox(
                                      //   width: 15,
                                      // ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        margin: const EdgeInsets.only(right: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: end == 0
                                                ? Colors.green[400]
                                                : const Color.fromARGB(
                                                    255, 28, 35, 39)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              prod[index]["qrScan"].toString(),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 25,
                                            ),
                                            Text(
                                              prod[index]["qrdate"].toString(),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              prod[index]["qrTime"].toString(),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
      floatingActionButton: Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: IconButton(
          iconSize: 40,
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/addBill");
          },
        ),
      ),
    );
  }
}
