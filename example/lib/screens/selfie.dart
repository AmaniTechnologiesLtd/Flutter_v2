import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_amanisdk_v2/amani_sdk.dart';
import 'package:flutter_amanisdk_v2_example/screens/confim.dart';

class SelfieScreen extends StatefulWidget {
  const SelfieScreen({Key? key}) : super(key: key);

  @override
  State<SelfieScreen> createState() => _SelfieScreenState();
}

class _SelfieScreenState extends State<SelfieScreen> {
  final _amaniSelfie = AmaniSDK().getSelfie();

  static const routeName = "/selfie";

  Future<void> initSDK() async {
    await _amaniSelfie.setType("XXX_SE_0");
  }

  @override
  void initState() {
    super.initState();
    initSDK();
  }

  Future<bool> onWillPop() async {
    if (Platform.isAndroid) {
      try {
        bool canPop = await _amaniSelfie.androidBackButtonHandle();
        return canPop;
      } catch (e) {
        return true;
      }
    } else {
      // default behaviour for iOS
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text("Selfie"),
        ),
        body: Center(
          child: OutlinedButton(
            onPressed: () async {
              await _amaniSelfie.start().then((imageData) {
                Navigator.pushNamed(context, ConfirmScreen.routeName,
                    arguments: ConfirmArguments(
                        source: "selfie", imageData: imageData));
              }).catchError((err) {
                throw Exception(err);
              });
            },
            child: const Text('Start Selfie'),
          ),
        ),
      ),
    );
  }
}
