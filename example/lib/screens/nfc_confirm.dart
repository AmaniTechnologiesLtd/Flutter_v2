import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_amanisdk_v2/amani_sdk.dart';

class NFCConfrimScreen extends StatefulWidget {
  const NFCConfrimScreen({super.key});
  static const routeName = '/confirm-nfc';

  @override
  State<NFCConfrimScreen> createState() => _NFCConfrimScreenState();
}

class _NFCConfrimScreenState extends State<NFCConfrimScreen> {
  bool _isCapturing = false;
  bool _uploadState = false;
  final _idCapture = AmaniSDK().getIDCapture();
  final _androidNFCCapture = AmaniSDK().getAndroidNFCCapture();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Capture NFC"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text("Is Capturing: $_isCapturing"),
              Text("Upload State: $_uploadState"),
              OutlinedButton(
                  onPressed: () {
                    if (Platform.isAndroid) {
                      _idCapture.setAndroidUsesNFC(true).then((_) {
                        setState(() {
                          _isCapturing = true;
                        });
                        _androidNFCCapture.startNFCListener(
                            onFinishedCallback: (isCaptureComplete) {
                          setState(() {
                            _isCapturing = false;
                            _uploadState = true;
                          });
                          _idCapture.upload().then((uploadState) {
                            setState(() {
                              _uploadState = uploadState;
                            });
                            Navigator.pushReplacementNamed(context, '/');
                          });
                        });
                      });
                    }
                  },
                  child: const Text("Start Capture"))
            ],
          )
        ],
      ),
    );
  }
}
