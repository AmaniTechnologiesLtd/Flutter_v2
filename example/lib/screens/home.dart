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
        .initAmaniWithEmail(
            server: "https://dev.amani.ai",
            email: "deniz@amani.ai",
            password: "uecJQ*B47+\$QVW.",
            customerIdCardNumber: "38203450858",
            useLocation: true, // Use location when uploading customer data
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

    AmaniSDK().setDelegateMethods(
        amaniOnError, amaniOnProfileStatus, amaniOnStepResult);
  }

  void amaniOnError(String errorType, List<dynamic> errors) {
    print(errorType);
    print(errors);
  }

  void amaniOnProfileStatus(Map<String, dynamic> profileStatus) {
    print(profileStatus);
  }

  void amaniOnStepResult(List<dynamic> stepResult) {
    print(stepResult);
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
