import 'dart:convert';

import 'package:aone/data.dart';
import 'package:aone/main.dart';
import 'package:aone/modules/produc_module.dart';
import 'package:aone/screens/avtiveCode_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../widgets/BiscBottom_Widget.dart';
import '../widgets/textField_Wdiget.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameContorller = TextEditingController();

  final priceContorller = TextEditingController();
  final payContorller = TextEditingController();

  var result;

  @override
  void initState() {
    super.initState();
    checkConnectitivy();
    if (preferences.getString('product') != null &&
        result != ConnectivityResult.none) {
      String productJson = preferences.getString('product')!;
      ProductModule product = ProductModule.fromJson(jsonDecode(productJson));

      var collection = FirebaseFirestore.instance.collection("product");
      collection.add(product.toJson()).then((value) => {
            Fluttertoast.showToast(msg: "product Upload Successfully "),
          });
      preferences.remove('product');
    }
  }

  void checkConnectitivy() async {
    result = await Connectivity().checkConnectivity();
    print(result);
  }

  @override
  void dispose() {
    nameContorller.dispose();
    priceContorller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text('اضافة منتج'),
        leading: IconButton(
          icon: const Icon(Icons.logout_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFieldWidget(
              controller: nameContorller,
              hint: 'اسم المنتج ',
            ),
            TextFieldWidget(
              controller: priceContorller,
              hint: 'السعر',
              type: TextInputType.number,
            ),
            const SizedBox(
              height: 15,
            ),
            Flexible(
              child: BaiscBottomWidget(
                text: "اضافة ",
                onTap: () async {
                  if (nameContorller.text.isNotEmpty &
                      priceContorller.text.isNotEmpty) {
                    ProductModule p1 = ProductModule(
                      name: nameContorller.text,
                      price: priceContorller.text,
                    );
                    print(result);
                    if (result != ConnectivityResult.none) {
                      var collection =
                          FirebaseFirestore.instance.collection("product");
                      collection.add(p1.toJson()).then((value) => {
                            Fluttertoast.showToast(
                                msg: "product Created Successfully "),
                            priceContorller.clear(),
                            nameContorller.clear(),
                            payContorller.clear(),
                          });
                    } else {
                      String productJson = jsonEncode(p1.toJson());
                      await preferences.setString('product', productJson);
                      priceContorller.clear();
                      nameContorller.clear();

                      Fluttertoast.showToast(msg: "تم الحفظ في الذاكرة");
                    }
                  } else {
                    Fluttertoast.showToast(msg: "يجب تعبئة كل الحقول ");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
