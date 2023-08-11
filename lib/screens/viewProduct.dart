import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data.dart';
import '../widgets/textField_Wdiget.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  late TextEditingController _titleControler;
  late TextEditingController _priceControler;
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleControler = TextEditingController();
    _priceControler = TextEditingController();
  }

  Future<String?> openDialog(String id) => showDialog(
        context: context,
        builder: (builder) => AlertDialog(
          title: const Text("تعديل منتج"),
          content: SizedBox(
            height: 150,
            child: Column(
              children: [
                TextFieldWidget(
                  hint: 'اسم المنتج',
                  controller: _titleControler,
                ),
                TextFieldWidget(
                  controller: _priceControler,
                  hint: 'السعر',
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
                        FirebaseFirestore.instance.collection('product');
                    await productsRef.doc(id).set({
                      'name': _titleControler.text,
                      'price': _priceControler.text
                    }).then((value) {
                      _priceControler.clear();
                      _titleControler.clear();
                      Fluttertoast.showToast(msg: "تمت اضافة المنتج");
                      Navigator.pop(context);
                    });
                  },
                  child: const Text("تعديل"),
                ),
                TextButton(
                  onPressed: () {
                    _priceControler.clear();

                    _titleControler.clear();
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
          "المنتجات",
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
                  .collection("product")
                  .orderBy('name')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final prod = snapshot.data?.docs.toList();

                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 1.7),
                      itemCount: prod!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 0),
                          margin: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 5,
                          ),
                          height: 60,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 59, 67, 71),
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text(
                                    "اسم المنتج : ",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.blueAccent),
                                  ),
                                  Text(
                                    prod[index]["name"],
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "السعر : ",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.blueAccent),
                                  ),
                                  Text(
                                    prod[index]["price"],
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  const Text(
                                    " ل.س ",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.redAccent),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextButton(
                                    child: const Text("حذف",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.redAccent)),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('product')
                                          .doc(prod[index].id)
                                          .delete()
                                          .then(((value) =>
                                              Fluttertoast.showToast(
                                                  msg: " تم حذف المنتج")))
                                          .catchError((e) {
                                        Fluttertoast.showToast(msg: e!.message);
                                      });
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("تعديل",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                    onPressed: () async {
                                      _titleControler.text =
                                          prod[index]['name'];
                                      _priceControler.text =
                                          prod[index]['price'];
                                      openDialog(prod[index].id);
                                    },
                                  ),
                                ],
                              )
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
            Navigator.pushNamed(context, "/addProduct");
          },
        ),
      ),
    );
  }
}
