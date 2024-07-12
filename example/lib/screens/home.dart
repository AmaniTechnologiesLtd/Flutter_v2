import 'package:flutter/material.dart';
import 'package:flutter_amanisdk/amani_sdk.dart';
import 'package:flutter_amanisdk/common/models/api_version.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> initAmani() async {
    AmaniSDK()
        .initAmani(
            server: "https://demo2.amani.ai",
            customerToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzIwNzk1MTUyLCJpYXQiOjE3MjA3OTE1NTIsImp0aSI6ImRiYzI1ZDVmNGM5ZTQ4MTQ4NWQzODM5Y2I4ZGQ5NTVjIiwidXNlcl9pZCI6Ijg4Y2E1ZGIzLTJiMWEtNDdiMC04ZDRiLWMzYjk5ZWJiY2M1YSIsImFwaV91c2VyIjpmYWxzZSwiY29tcGFueV9pZCI6ImZjNGIyN2M2LTk3NzctNGYzMC1hNDc1LWE4MDFlNzFmZWY4MiIsInByb2ZpbGVfaWQiOiI4MTVjOTA4OS1jOTNiLTQxZDItYjhlNS1hN2UyZDBlNDEwZGUifQ.upsYTZ6CfcC_snF1w0KY6ko4M-qdz9dty6UGy1WaPpQ",
            customerIdCardNumber: "22180378472",
            useLocation: true,
            apiVersion: AmaniApiVersion.v2,
            lang: "tr")
        .then((_) {
      AmaniSDK().getCustomerInfo().then((value) {
        // get customer id
        print(value.id);
      });
    }).catchError((err) {
      throw Exception(err);
    });

    await for (final delegateEvent in AmaniSDK().getDelegateStream()) {
      print("delegate event recievedDDDD");
      print(delegateEvent);
    }
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
                    child: const Text("BioLogin")),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/document-capture');
                    },
                    child: const Text("Document Capture"))
              ]),
        ));
  }
}
