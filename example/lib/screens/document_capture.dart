import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_amanisdk/amani_sdk.dart';
import 'package:flutter_amanisdk/modules/document_capture.dart';
import 'package:flutter_amanisdk_example/screens/confim.dart';

class DocumentCaputureScreen extends StatefulWidget {
  const DocumentCaputureScreen({super.key});

  @override
  State<DocumentCaputureScreen> createState() => _DocumentCaputureScreenState();
}

class _DocumentCaputureScreenState extends State<DocumentCaputureScreen> {
  final DocumentCapture _documentCaptureModule =
      AmaniSDK().getDocumentCapture();

  Future<void> initSDK() async {
    await _documentCaptureModule.setType("TUR_IB_0");
  }

  @override
  void initState() {
    super.initState();
    initSDK();
  }

  Future<bool> onWillPop() async {
    if (Platform.isAndroid) {
      try {
        bool canPop = await _documentCaptureModule.androidBackButtonHandler();
        return canPop;
      } catch (e) {
        return true;
      }
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            title: const Text("Document Capture Screen")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: () {
                    _documentCaptureModule.start().then((image) {
                      Navigator.pushNamed(context, ConfirmScreen.routeName,
                          arguments: ConfirmArguments(
                              source: "documentCapture",
                              imageData: image,
                              idCaptureBothSidesTaken: false,
                              idCaptureNFCCompleted: false));
                    }).catchError((err) {});
                  },
                  child: const Text("Start"))
            ],
          ),
        ),
      ),
    );
  }
}
