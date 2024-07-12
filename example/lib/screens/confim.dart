import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_amanisdk/amani_sdk.dart';
import 'package:flutter_amanisdk/modules/id_capture.dart';
import 'package:flutter_amanisdk_example/screens/nfc_confirm.dart';
import 'package:flutter_amanisdk_example/screens/confirm_arguments.dart';


class ConfirmScreenState extends StatefulWidget {
   const ConfirmScreenState({super.key});
   static const routeName = '/confirm';

  @override
  State<ConfirmScreenState> createState() => _ConfirmScreen();
}

class _ConfirmScreen extends State<ConfirmScreenState> {
  static const eventChannel = EventChannel('amanisdk_delegate_channel');
  // Modules.
  final _idCapture = AmaniSDK().getIDCapture();
  final _autoSelfie = AmaniSDK().getAutoSelfie();
  final _selfie = AmaniSDK().getSelfie();
  final _poseEstimation = AmaniSDK().getPoseEstimation();
  final _documentCapture = AmaniSDK().getDocumentCapture();

  String _mrzData = "No Data";
  String _error = "No Error";

@override
  void initState() {
    super.initState();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  getMrzResult() async {
    try {
      eventChannel.receiveBroadcastStream().listen((data) { 
        print(data.toString());
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
 void _onEvent(dynamic event) {
    setState(() {
      if (event['type'] == 'mrzInfoDelegate') {
        _mrzData = event['data'];
      } else if (event['type'] == 'error') {
        _error = "Error: ${event['data']['error_message']}";
      }
    });
  }

  void _onError(Object error) {
    setState(() {
      _error = "Error: $error";
    });
  }

Future<void> _connectToSocket() async {
       await for (final delegateEvent in AmaniSDK().getDelegateStream()) {
      print("delegate event recievedDDDD");
      print(delegateEvent);
    }
}


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
                    _idCapture.getMrzRequest().then((mrzDocumentId) {
                          print('MRZ DOCUMENT ID CONFIRM EKRANI: $mrzDocumentId');
                           _connectToSocket();
                       if (mrzDocumentId != null) {
                        /*
                         _idCapture.iosStartNFC(mrzDocumentId).then((isDone) {
                           Navigator.pushNamed(context, ConfirmScreenState.routeName,
                              arguments: ConfirmArguments(
                                  source: "idCapture",
                                  imageData: args.imageData,
                                  idCaptureBothSidesTaken: true,
                                  idCaptureNFCCompleted: true));
                              });   
                              */  
                          }
                        }); 





                        /*
                          if (mrzDataResult != null) {
                               _idCapture.iosStartNFC(mrzDocumentId).then((isDone) {
                          Navigator.pushNamed(context, ConfirmScreenState.routeName,
                              arguments: ConfirmArguments(
                                  source: "idCapture",
                                  imageData: args.imageData,
                                  idCaptureBothSidesTaken: true,
                                  idCaptureNFCCompleted: true));
                        });
                          } else {
                            print("Protocol delegate tetiklenmedi");
                          }
                          */ 
                      } else if (Platform.isAndroid) {
                        Navigator.pushNamed(
                            context, NFCConfrimScreen.routeName);
                      }
                    } else if (args.source == "idCapture" &&
                        args.idCaptureBothSidesTaken == false) {
                      _idCapture.start(IdSide.back).then((imageData) {
                        Navigator.pushNamed(context, ConfirmScreenState.routeName,
                                arguments: ConfirmArguments(
                                    source: "idCapture",
                                    imageData: imageData,
                                    idCaptureBothSidesTaken: true,
                                    idCaptureNFCCompleted: false))
                            .then((_) {
                          if (Platform.isIOS) {
                            _idCapture.getMrzRequest().then((mrzDocumentId) {
                                print('MRZ DOCUMENT ID CONFIRM EKRANI: $mrzDocumentId');
                                _connectToSocket();
                                if (mrzDocumentId != null) {
                                  /*
                         _idCapture.iosStartNFC(mrzDocumentId).then((isDone) {
                           Navigator.pushNamed(context, ConfirmScreenState.routeName,
                              arguments: ConfirmArguments(
                                  source: "idCapture",
                                  imageData: args.imageData,
                                  idCaptureBothSidesTaken: true,
                                  idCaptureNFCCompleted: true));
                              });      
                              */
                          }
                        }); 
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

