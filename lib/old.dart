// Row(
//             children: [
//               Flexible(
//                   child: Column(
//                 children: [
//                   BaiscBottomWidget(text: "تسجيل", onTap: () {}),
//                   BaiscBottomWidget(
//                       text: "مسح البيانات",
//                       onTap: () {
//                         print("object");
//                         // Navigator.pushNamed(context, '/insert');
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: const Text('تأكيد الحذف'),
//                               content: Container(
//                                 height: 90,
//                                 child: Column(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     const Text(
//                                         'هل أنت متأكد من رغبتك في الحذف؟'),
//                                     TextFieldWidget(
//                                         hint: "رمز التأكيد",
//                                         controller: contorller)
//                                   ],
//                                 ),
//                               ),
//                               actions: [
//                                 TextButton(
//                                   child: const Text('إلغاء'),
//                                   onPressed: () {
//                                     Navigator.of(context)
//                                         .pop(); // إغلاق حوار التأكيد
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: const Text('حذف'),
//                                   onPressed: () {
//                                     if (contorller.text == "0000") {
//                                       // قم بحذف المستند من Firestore
//                                       FirebaseFirestore.instance
//                                           .collection('product')
//                                           .get()
//                                           .then((snapshot) {
//                                         for (DocumentSnapshot doc
//                                             in snapshot.docs) {
//                                           doc.reference.delete();
//                                         }
//                                         Fluttertoast.showToast(
//                                             msg: 'تم حذف المجموعة بنجاح');
//                                       }).catchError((error) {
//                                         Fluttertoast.showToast(
//                                             msg:
//                                                 'حدث خطأ أثناء حذف المجموعة: $error');
//                                       });
//                                     } else {
//                                       Fluttertoast.showToast(
//                                           msg: 'يرجى ادخال رمز صحيح');
//                                     }
//                                   },
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       }),
//                 ],
//               )),
//               Flexible(
//                   child: Column(
//                 children: [
//                   BaiscBottomWidget(
//                       text: "المنتجات",
//                       onTap: () {
//                         Navigator.pushNamed(context, "/viewProduct");
//                       }),
//                   BaiscBottomWidget(
//                       text: "المندوبين",
//                       onTap: () {
//                         Navigator.pushNamed(context, "/clinet");
//                       }),
//                 ],
//               )),
//             ],
//           ),
//           Row(
//             children: [
//               Flexible(
//                 child: BaiscBottomWidget(
//                     text: "الطلبيات",
//                     onTap: () {
//                       Navigator.pushNamed(context, "/viewBill");
//                     }),
//               ),
//               Flexible(
//                 child: BaiscBottomWidget(
//                     text: "حول الشركة",
//                     onTap: () {
//                       Navigator.pushNamed(context, "/about");
//                     }),
//               ),
//             ],
//           )