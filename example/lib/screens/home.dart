import 'package:flutter/material.dart';
import 'package:flutter_amanisdk_v2/amani_sdk.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> initAmani() async {
    await AmaniSDK()
        .initAmani(
            server: "https://demo.amani.ai",
            customerToken:
                "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyMCwiZXhwIjoxNjY5NjI2MTQ2LCJ1c2VybmFtZSI6Im1vYmlsZV90ZWFtQGFtYW5pLmFpIn0.xeHw-iJ6dPfpHy_2J0EPdbGvmSdoT2mu0epPENz_TsA",
            customerIdCardNumber: "1234678",
            useLocation: true,
            lang: "tr")
        .then((value) => print(value))
        .catchError((err) {
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
                      Navigator.pushNamed(context, '/nfc-ios');
                    },
                    child: const Text('NFC'))
              ]),
        ));
  }
}
