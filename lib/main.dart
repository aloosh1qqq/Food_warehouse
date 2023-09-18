import 'package:aone/firebase_options.dart';
import 'package:aone/screens/About.dart';
import 'package:aone/screens/addBill_screen.dart';
import 'package:aone/screens/addProduct_screen.dart';
import 'package:aone/screens/avtiveCode_screen.dart';
import 'package:aone/screens/billView_screen.dart';
import 'package:aone/screens/clinet_screen.dart';
import 'package:aone/screens/insarte_screen.dart';
import 'package:aone/screens/logIn_screen.dart';
import 'package:aone/screens/qrScanere.dart';
import 'package:aone/screens/shose_screen.dart';
import 'package:aone/screens/signup_screen.dart';
import 'package:aone/screens/viewProduct.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences preferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  preferences = await SharedPreferences.getInstance();

  // preferences.clear();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: '/addBill',
      routes: {
        // '/': (context) => const SignupPage(),
        '/': (context) {
          if (preferences.getString("active") != null) {
            if (preferences.getString("userType") == null) {
              return LogInScreen();
            } else {
              return const ShoseScreen();
            }
          } else {
            return const ActiveCode();
          }
        },
        '/login': (context) => LogInScreen(),
        '/shose': (context) => const ShoseScreen(),
        '/insert': (context) => InsertScreen(),
        '/qrscan': (context) => const QrScan(),
        '/addProduct': (context) => const AddProductScreen(),
        '/viewProduct': (context) => const ViewProduct(),
        '/clinet': (context) => const ClinetScreen(),
        '/addBill': (context) => const AddBillScreen(),
        '/viewBill': (context) => const ViewBill(),
        '/about': (context) => AAbout(),
      },
    );
  }
}
