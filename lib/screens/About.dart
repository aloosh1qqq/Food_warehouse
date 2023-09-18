import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AAbout extends StatelessWidget {
  AAbout({super.key});
  Future<void> _launchInBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  final Uri phone = Uri.parse('tel:+963-9415-377-81');
  final Uri whatsApp = Uri.parse('https://wa.me/+963941537781');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/image/logo.jpg"),
            const Text(
              "شركة قضيماتي ",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "رقم الهاتف : 00963941537781",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      _launchInBrowser(
                          "https://www.facebook.com/Qadimati?mibextid=ZbWKwL");
                    },
                    icon: const Icon(
                      Icons.facebook_outlined,
                      size: 40,
                      color: Colors.blueAccent,
                    )),
                IconButton(
                    onPressed: () {
                      launchUrl(phone);
                    },
                    icon: const Icon(
                      Icons.call,
                      size: 40,
                      color: Colors.blueAccent,
                    )),
                IconButton(
                    onPressed: () {
                      launchUrl(whatsApp);
                    },
                    icon: const Icon(
                      Icons.message,
                      size: 40,
                      color: Colors.greenAccent,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
