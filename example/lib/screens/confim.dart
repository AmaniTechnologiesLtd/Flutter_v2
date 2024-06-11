import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_amanisdk/amani_sdk.dart';
import 'package:flutter_amanisdk/modules/id_capture.dart';
import 'package:flutter_amanisdk_example/screens/nfc_confirm.dart';

class ConfirmScreen extends StatelessWidget {
  ConfirmScreen({Key? key}) : super(key: key);
  // Modules.
  final _idCapture = AmaniSDK().getIDCapture();
  final _autoSelfie = AmaniSDK().getAutoSelfie();
  final _selfie = AmaniSDK().getSelfie();
  final _poseEstimation = AmaniSDK().getPoseEstimation();
  final _documentCapture = AmaniSDK().getDocumentCapture();

  static const routeName = '/confirm';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ConfirmArguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Confirm Document?"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.memory(
            args.imageData,
            fit: BoxFit.contain,
            width: double.infinity,
            height: 450,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: (() => Navigator.pop(context)),
                  child: const Text("Try again!")),
              OutlinedButton(
                  onPressed: (() {
                    if (args.source == "idCapture" &&
                        args.idCaptureBothSidesTaken == true &&
                        args.idCaptureNFCCompleted == true) {
                      _idCapture.upload().then((isSuccess) {
                        if (isSuccess) {
                          Navigator.pushReplacementNamed(context, '/');
                        }
                      });
                    } else if (args.source == "idCapture" &&
                        args.idCaptureBothSidesTaken == true &&
                        args.idCaptureNFCCompleted == false) {
                      if (Platform.isIOS) {
                        
                        _idCapture.iosStartNFC().then((isDone) {
                          Navigator.pushNamed(context, ConfirmScreen.routeName,
                              arguments: ConfirmArguments(
                                  source: "idCapture",
                                  imageData: args.imageData,
                                  idCaptureBothSidesTaken: true,
                                  idCaptureNFCCompleted: true));
                        });
                      } else if (Platform.isAndroid) {
                        Navigator.pushNamed(
                            context, NFCConfrimScreen.routeName);
                      }
                    } else if (args.source == "idCapture" &&
                        args.idCaptureBothSidesTaken == false) {
                      _idCapture.start(IdSide.back).then((imageData) {
                        Navigator.pushNamed(context, ConfirmScreen.routeName,
                                arguments: ConfirmArguments(
                                    source: "idCapture",
                                    imageData: imageData,
                                    idCaptureBothSidesTaken: true,
                                    idCaptureNFCCompleted: false))
                            .then((_) {
                          if (Platform.isIOS) {
                            _idCapture.iosStartNFC().then((value) => null);
                          }
                        });
                      });
                    } else if (args.source == "selfie") {
                      _selfie.upload().then((isSuccess) {
                        if (isSuccess) {
                          Navigator.pushReplacementNamed(context, '/');
                        }
                      });
                    } else if (args.source == "autoSelfie") {
                      _autoSelfie.upload().then((isSuccess) {
                        if (isSuccess) {
                          Navigator.pushReplacementNamed(context, '/');
                        }
                      });
                    } else if (args.source == "poseEstimation") {
                      _poseEstimation.upload().then((isSuccess) {
                        if (isSuccess) {
                          Navigator.pushReplacementNamed(context, '/');
                        }
                      });
                    } else if (args.source == "documentCapture") {
                      _documentCapture.startUploadWithFiles(null).then((isSuccess) {
                        Navigator.pushReplacementNamed(context, '/');
                      });
                    }
                  }),
                  child: const Text("Confirm"))
            ],
          )
        ],
      ),
    );
  }
}

class ConfirmArguments {
  final String source;
  final Uint8List imageData;
  final bool? idCaptureBothSidesTaken;
  final bool? idCaptureNFCCompleted;
  ConfirmArguments(
      {required this.source,
      required this.imageData,
      this.idCaptureBothSidesTaken,
      this.idCaptureNFCCompleted});
}
