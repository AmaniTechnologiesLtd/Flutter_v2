import 'package:flutter/material.dart';

class NFCHome extends StatelessWidget {
  const NFCHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("NFC Capture"),
      ),
      body: Center(
          child: Column(
        children: [
          OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/nfc-ios');
              },
              child: const Text("iOS")),
          OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/nfc-android');
              },
              child: const Text("Android"))
        ],
      )),
    );
  }
}
