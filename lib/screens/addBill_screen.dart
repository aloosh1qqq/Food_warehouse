import 'dart:convert';

import 'package:aone/main.dart';

import 'package:aone/screens/avtiveCode_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../modules/bill_modle.dart';
import '../widgets/BiscBottom_Widget.dart';
import '../widgets/textField_Wdiget.dart';

class AddBillScreen extends StatefulWidget {
  const AddBillScreen({super.key});

  @override
  State<AddBillScreen> createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final quanttiContorller = TextEditingController();

  final payContorller = TextEditingController();
  final qrkey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;
  bool show = false;
  var result;
  var time = DateTime.now();
  String name = 'اختر المنتج';
  String price = '0';
  @override
  void initState() {
    super.initState();
    checkConnectitivy();
    if (preferences.getString('bill') != null &&
        result != ConnectivityResult.none) {
      String billJson = preferences.getString('bill')!;
      BillModule bill = BillModule.fromJson(jsonDecode(billJson));

      var collection = FirebaseFirestore.instance.collection("bill");
      collection.add(bill.toJson()).then((value) => {
            Fluttertoast.showToast(msg: "bill Upload Successfully "),
          });
      preferences.remove('bill');
    }
  }

  void checkConnectitivy() async {
    result = await Connectivity().checkConnectivity();
    print(result);
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((event) {
      setState(() {
        show = false;
        barcode = event;
        time = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();

    quanttiContorller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text('اضافة طلبية'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('product')
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<DropdownMenuItem> clientItem = [];
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      final clients = snapshot.data?.docs.reversed.toList();
                      for (var client in clients!) {
                        clientItem.add(DropdownMenuItem(
                          value: client,
                          child: Text(client['name']),
                        ));
                      }
                      return DropdownButton(
                          alignment: Alignment.center,
                          hint: Text(
                            name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          isExpanded: true,
                          items: clientItem,
                          onChanged: (v) {
                            setState(() {
                              name = v['name'];
                              price = v['price'];
                            });
                          });
                    }
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    price,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    " :السعر",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              TextFieldWidget(
                controller: quanttiContorller,
                type: TextInputType.number,
                hint: 'الكمية ',
              ),
              TextFieldWidget(
                controller: payContorller,
                hint: 'الدفعة',
                type: TextInputType.number,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Flexible(
                    child: BaiscBottomWidget(
                      text: "اضافة ",
                      onTap: () async {
                        if (price != '0' && quanttiContorller.text.isNotEmpty) {
                          if (barcode != null) {
                            BillModule p1 = BillModule(
                                name: name,
                                sub: preferences.get("userName").toString(),
                                quantity: quanttiContorller.text,
                                price: price,
                                qrTime: " الوقت:${time.hour}:${time.minute}",
                                qrdate:
                                    "التاريخ: ${time.year}/${time.day}/${time.month}",
                                qrScan: barcode!.code,
                                pay: payContorller.text.isNotEmpty
                                    ? payContorller.text
                                    : "0",
                                pay1: "0",
                                pay2: "0",
                                pay3: "0",
                                user: preferences.getString('useradmin'));
                            print(result);
                            if (result != ConnectivityResult.none) {
                              var collection =
                                  FirebaseFirestore.instance.collection("bill");
                              collection.add(p1.toJson()).then((value) => {
                                    Fluttertoast.showToast(
                                        msg: "bill Created Successfully "),
                                    name = 'اختر المنتج',
                                    price = '0',
                                    quanttiContorller.clear(),
                                    payContorller.clear(),
                                    barcode = null,
                                  });
                            } else {
                              String billJson = jsonEncode(p1.toJson());
                              await preferences.setString('bill', billJson);
                              name = 'اختر المنتج';
                              price = '0';
                              quanttiContorller.clear();
                              barcode = null;
                              Fluttertoast.showToast(
                                  msg: "تم الحفظ في الذاكرة");
                            }
                          } else {
                            Fluttertoast.showToast(msg: "يرجى مسح الباركود");
                          }
                        } else {
                          Fluttertoast.showToast(msg: "يجب تعبئة كل الحقول ");
                        }
                      },
                    ),
                  ),
                  Flexible(
                    child: BaiscBottomWidget(
                      onTap: () {
                        setState(() {
                          show = true;
                        });
                        // Navigator.pushNamed(context, "/qrscan");
                      },
                      text: "QR مسح",
                    ),
                  ),
                ],
              ),
              show
                  ? SizedBox(
                      height: 300,
                      width: 300,
                      child: buildQrView(context),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQrView(BuildContext context) {
    return QRView(
      key: qrkey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8),
    );
  }

  Widget buildResult() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.white24),
        child: Text(
          barcode != null ? 'Result : ${barcode!.code}' : 'Scan a code!',
          maxLines: 3,
        ),
      );
}
