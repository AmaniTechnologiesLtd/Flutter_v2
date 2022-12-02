import 'package:flutter/material.dart';
import 'package:flutter_amanisdk_v2/amani_sdk.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> initAmani() async {
    AmaniSDK()
        .initAmani(
            server: "https://server.example",
            customerToken: "",
            customerIdCardNumber: "id card of the customer",
            useLocation: true, // Use location when uploading customer data
            lang: "tr")
        .then((_) {
      AmaniSDK().getCustomerInfo().then((value) {
        // get customer id
        print(value.id);
      });
    }).catchError((err) {
      throw Exception(err);
    });
  }

  @override
  void initState() {
    super.initState();
    initAmani();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('Amani Flutter SDK Demo')),
        body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/id-capture");
                    },
                    child: const Text('ID Capture')),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/selfie');
                    },
                    child: const Text('Selfie')),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/auto-selfie');
                    },
                    child: const Text('Auto Selfie')),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/pose-estimation');
                    },
                    child: const Text('Pose Estimation')),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/nfc');
                    },
                    child: const Text('NFC')),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/bio-login');
                    },
                    child: const Text("BioLogin"))
              ]),
        ));
  }
}
