import 'package:aone/widgets/textField_Wdiget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data.dart';

class ViewBill extends StatefulWidget {
  const ViewBill({super.key});

  @override
  State<ViewBill> createState() => _ViewBillState();
}

class _ViewBillState extends State<ViewBill> {
  late TextEditingController _priceControler;
  void initState() {
    // TODO: implement initState
    super.initState();

    _priceControler = TextEditingController();
  }

  Future<String?> openDialog(String id, String pay) => showDialog(
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
                    int sum = int.parse(pay) + int.parse(_priceControler.text);
                    final CollectionReference productsRef =
                        FirebaseFirestore.instance.collection('bill');
                    await productsRef.doc(id).update({
                      'pay': sum.toString(),
                    }).then((value) {
                      _priceControler.clear();
                      Fluttertoast.showToast(msg: "تمت اضافة الدفعة");
                      Navigator.pop(context);
                    });
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
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
              stream: FirebaseFirestore.instance
                  .collection("bill")
                  .orderBy('qrTime', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final prod = snapshot.data?.docs.toList();

                  return ListView.builder(
                      itemCount: prod!.length,
                      itemBuilder: (context, index) {
                        int total = int.parse(prod[index]["price"]) *
                            int.parse(prod[index]["quantity"]);
                        int end = total - int.parse(prod[index]["pay"]);
                        return GestureDetector(
                          onLongPress: () async {
                            openDialog(
                              prod[index].id,
                              prod[index]["pay"],
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(15),
                            height: 300,
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
                                    const SizedBox(
                                      height: 15,
                                    ),
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
                                    const SizedBox(
                                      height: 15,
                                    ),
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
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const Text(
                                      "الاجمالي",
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
                                      borderRadius: BorderRadius.circular(25),
                                      color: const Color.fromARGB(
                                          255, 28, 35, 39)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        prod[index]["qrScan"].toString(),
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                      Text(
                                        prod[index]["qrTime"].toString(),
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
