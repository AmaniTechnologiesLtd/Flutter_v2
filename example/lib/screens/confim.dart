import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_amanisdk/amani_sdk.dart';
import 'package:flutter_amanisdk/common/models/nvi_data.dart';
import 'package:flutter_amanisdk/modules/id_capture.dart';
import 'package:flutter_amanisdk_example/screens/nfc_confirm.dart';


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

class ConfirmScreenState extends StatefulWidget {
  const ConfirmScreenState({super.key});
  static const routeName = '/confirm';

  @override
  State<ConfirmScreenState> createState() => _ConfirmScreen();
}

class _ConfirmScreen extends State<ConfirmScreenState> {
  static const eventChannel = EventChannel('amanisdk_delegate_channel');

  StreamSubscription<dynamic>? _eventSubscription;
  final _idCapture = AmaniSDK().getIDCapture();
  final _autoSelfie = AmaniSDK().getAutoSelfie();
  final _selfie = AmaniSDK().getSelfie();
  final _poseEstimation = AmaniSDK().getPoseEstimation();
  final _documentCapture = AmaniSDK().getDocumentCapture();

  String _error = "No Error";
  Map<String, dynamic> mrzResult = {};
  String? mrzDocId = "";
  int mrzReqCount = 0;
  bool _isLoading = false;


  Future<String?> startMrzRequest() async {
    final String? mrzDocId = await _idCapture.getMrzRequest();
    return mrzDocId;
  }

  @override 
  void initState() {
    super.initState();
    startListeningForMrzResult();
  }


  @override
Widget build(BuildContext context) {
  final args = ModalRoute.of(context)!.settings.arguments as ConfirmArguments;

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.deepPurple,
      title: const Text("Confirm Document?"),
    ),
    body: _isLoading
    ?Center(child: CircularProgressIndicator())
     :Column(
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
                onPressed: (() async {
                 setState(() {
                   _isLoading = true;
                 });
                  if (args.source == "idCapture" &&
                      args.idCaptureBothSidesTaken == true &&
                      args.idCaptureNFCCompleted == true) {
                    bool isSuccess = await _idCapture.upload();
                    if (isSuccess) {
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  } else if (args.source == "idCapture" &&
                      args.idCaptureBothSidesTaken == true &&
                      args.idCaptureNFCCompleted == false) {
                    if (Platform.isIOS) {
                     String? mrzDocumentId = await startMrzRequest();
                     print("CONFIRM BUTTON CLICK MRZDOCUMENTID $mrzDocumentId");
                     setState(() {
                       mrzDocId = mrzDocumentId;
                     });
                       await startListeningForMrzResult();
                      await Future.delayed(Duration(seconds: 5));
                      print("StartListening fonk içerisine girdi ve timer çalıştı:");
                      if (mrzDocId != null && mrzResult.isNotEmpty) {
                        bool isDone = await _idCapture.iosStartNFC(mrzDocId!, mrzResult);
                        if (isDone) {
                         bool isSuccess = await _idCapture.upload(); 
                          if (isSuccess) {
                            Navigator.pushNamed(context, ConfirmScreenState.routeName,
                            arguments: ConfirmArguments(
                            source: "idCapture",
                            imageData: args.imageData,
                            idCaptureBothSidesTaken: true,
                            idCaptureNFCCompleted: true));
                          }
                          print("CONFIRM EKRANINDA UPLOAD ISLEMI TAMAMLANDI: $isSuccess");
                        }
                        
                      } else {
                        print("$mrzDocId ya da $mrzResult değerleri NULL GELDİ");
                      }
                    } else if (Platform.isAndroid) {
                      Navigator.pushNamed(context, NFCConfrimScreen.routeName);
                    }
                  } else if (args.source == "idCapture" &&
                      args.idCaptureBothSidesTaken == false) {
                    var imageData = await _idCapture.start(IdSide.back);
                    Navigator.pushNamed(context, ConfirmScreenState.routeName,
                        arguments: ConfirmArguments(
                            source: "idCapture",
                            imageData: imageData,
                            idCaptureBothSidesTaken: true,
                            idCaptureNFCCompleted: false))
                        .then((_) async {
                      if (Platform.isIOS) {
                     await startMrzRequest().then((mrzDocumentId) {
                        setState(() {
                          mrzDocId = mrzDocumentId;
                          print("CONFIRM EKRANINDA MRZDOCUMENT ID DEGERI  : $mrzDocumentId");
                        });
                      });
                      
                      await Future.delayed(Duration(seconds: 3));
                        if (mrzDocId != null && mrzResult.isNotEmpty) {
                          bool isDone = await _idCapture.iosStartNFC(mrzDocId!, mrzResult);
                          if (isDone) {
                          bool isSuccess = await _idCapture.upload(); 
                          if (isSuccess) {
                            Navigator.pushNamed(context, ConfirmScreenState.routeName,
                            arguments: ConfirmArguments(
                            source: "idCapture",
                            imageData: args.imageData,
                            idCaptureBothSidesTaken: true,
                            idCaptureNFCCompleted: true));
                          }
                       
                          }
                          print("CONFIRM EKRANINDA ISDONE DEGERI 1: $isDone");
                        } else {
                          print("$mrzDocId ya da $mrzResult değerleri NULL GELDİ");
                        }
                      }
                    });
                  } else if (args.source == "selfie") {
                    bool isSuccess = await _selfie.upload();
                    if (isSuccess) {
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  } else if (args.source == "autoSelfie") {
                    bool isSuccess = await _autoSelfie.upload();
                    if (isSuccess) {
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  } else if (args.source == "poseEstimation") {
                    bool isSuccess = await _poseEstimation.upload();
                    if (isSuccess) {
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  } else if (args.source == "documentCapture") {
                    bool isSuccess = await _documentCapture.startUploadWithFiles(null);
                    if (isSuccess) {
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  }
                }),
                child: const Text("Confirm"))
          ],
        )
      ],
    ),
  );
}


  Future<Map<String, dynamic>> _processAndStartNFC(String mrzString) async {
    Map<String, dynamic> mrzData = await _idCapture.processNFC(mrzString);
    mrzResult.addAll(mrzData);
    return mrzResult;
  }

  Future<Map<String, dynamic>> startListeningForMrzResult() async {
    Map<String, dynamic> mrzData = {};
     eventChannel.receiveBroadcastStream().listen((event) {
      if (event['type'] == 'mrzInfoDelegate') {
        if (event['data'] is String) {
          setState(() {
            _processAndStartNFC(event['data']);
            _isLoading = false;
          });        
        }
        print("CONFIRM EKRANI MRZ DATA WIDGET'A GONDERILICEK $mrzResult");
      } else if (event['type'] == 'error') {
        setState(() {
          _error = "Hata: ${event['data']['error_message']}";
          _isLoading = false; // Stop the spinner
        });
      }
    }, onError: (error) {
      setState(() {
        _error = "Error: $error";
         // Stop the spinner
      });
    });

    return mrzData;
  }
}


/*
class ConfirmScreenState extends StatefulWidget {
  const ConfirmScreenState({super.key});
  static const routeName = '/confirm';

  @override
  State<ConfirmScreenState> createState() => _ConfirmScreen();
}

class _ConfirmScreen extends State<ConfirmScreenState> {
  static const eventChannel = EventChannel('amanisdk_delegate_channel');

  final _idCapture = AmaniSDK().getIDCapture();
  final _autoSelfie = AmaniSDK().getAutoSelfie();
  final _selfie = AmaniSDK().getSelfie();
  final _poseEstimation = AmaniSDK().getPoseEstimation();
  final _documentCapture = AmaniSDK().getDocumentCapture();

  Map<String, dynamic> mrzResult = {};
  String? mrzDocumentId = "";
  String _error = "No Error";
  bool _isLoading = false;

 @override
  void initState() {
    super.initState();
    startMrzRequest();
  }
  
  Future<String?> startMrzRequest() async {
    print("CONFIRM EKRANINDA STARTMRZ FONKSİYONA GİRDİ -----");
     await _idCapture.getMrzRequest().then((mrzDocId) {
        mrzDocumentId = mrzDocId;
     });
    
    return mrzDocumentId;
  }

  Future<Map<String, dynamic>> startListeningForMrzResult() async {
    Map<String, dynamic> mrzData = {};
     eventChannel.receiveBroadcastStream().listen((event) {
      if (event['type'] == 'mrzInfoDelegate') {
        if (event['data'] is String) {
          setState(() {
            _processAndStartNFC(event['data']);
            
          });        
        }
        print("CONFIRM EKRANI MRZ DATA WIDGET'A GONDERILICEK $mrzResult");
      } else if (event['type'] == 'error') {
        setState(() {
          _error = "Hata: ${event['data']['error_message']}";
          _isLoading = false; // Stop the spinner
        });
      }
    }, onError: (error) {
      setState(() {
        _error = "Error: $error";
         // Stop the spinner
      });
    });

    return mrzData;
  }

  Future<Map<String, dynamic>> _processAndStartNFC(String mrzString) async {
    Map<String, dynamic> mrzData = await _idCapture.processNFC(mrzString);
    mrzResult.addAll(mrzData);

    return mrzResult;
  }

 

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ConfirmArguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Confirm Document?"),
      ),
      body: 
       Column(
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
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Try again!"),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        
                        if (args.source == "idCapture" &&
                            args.idCaptureBothSidesTaken == true &&
                            args.idCaptureNFCCompleted == true) {
                          bool isSuccess = await _idCapture.upload();
                          if (isSuccess) {
                            Navigator.pushReplacementNamed(context, '/');
                          }
                        } else if (args.source == "idCapture" &&
                            args.idCaptureBothSidesTaken == true &&
                            args.idCaptureNFCCompleted == false) {
                          if (Platform.isIOS) {
                            await startListeningForMrzResult().then((mrzValues) {
                              setState(() {
                                mrzResult = mrzValues;
                              });
                            });
                              if (mrzDocumentId != null && mrzResult.isEmpty != true) {
                                
                                _idCapture.iosStartNFC(mrzDocumentId, mrzResult).then((isDone) {
                                   Navigator.pushNamed(context, ConfirmScreenState.routeName,
                                   arguments: ConfirmArguments(
                                   source: "idCapture",
                                   imageData: args.imageData,
                                   idCaptureBothSidesTaken: true,
                                   idCaptureNFCCompleted: true));
                                });
                              } else {
                                print("MRZ RESULT BOS $mrzResult ----- MRZDOCID BOŞ $mrzDocumentId");
                              }
                           
                            
                          } else if (Platform.isAndroid) {
                            Navigator.pushNamed(context, NFCConfrimScreen.routeName);
                          }
                        } else if (args.source == "idCapture" &&
                            args.idCaptureBothSidesTaken == false) {
                          var imageData = await _idCapture.start(IdSide.back);
                          Navigator.pushNamed(context, ConfirmScreenState.routeName,
                              arguments: ConfirmArguments(
                                  source: "idCapture",
                                  imageData: imageData,
                                  idCaptureBothSidesTaken: true,
                                  idCaptureNFCCompleted: false))
                              .then((_) async {
                            if (Platform.isIOS) {
                                await startListeningForMrzResult().then((mrzValues) {
                                    setState(() {
                                      mrzResult = mrzValues;
                                    });
                                  });
                                  if (mrzDocumentId != null && mrzResult.isEmpty != true) {
                                _idCapture.iosStartNFC(mrzDocumentId, mrzResult).then((isDone) {
                                   Navigator.pushNamed(context, ConfirmScreenState.routeName,
                                   arguments: ConfirmArguments(
                                   source: "idCapture",
                                   imageData: args.imageData,
                                   idCaptureBothSidesTaken: true,
                                   idCaptureNFCCompleted: true));
                                });
                              } else {
                                print("MRZ RESULT BOS $mrzResult ----- MRZDOCID BOŞ $mrzDocumentId");
                              }
                            
                            }
                          });
                        } else if (args.source == "selfie") {
                          bool isSuccess = await _selfie.upload();
                          if (isSuccess) {
                            Navigator.pushReplacementNamed(context, '/');
                          }
                        } else if (args.source == "autoSelfie") {
                          bool isSuccess = await _autoSelfie.upload();
                          if (isSuccess) {
                            Navigator.pushReplacementNamed(context, '/');
                          }
                        } else if (args.source == "poseEstimation") {
                          bool isSuccess = await _poseEstimation.upload();
                          if (isSuccess) {
                            Navigator.pushReplacementNamed(context, '/');
                          }
                        } else if (args.source == "documentCapture") {
                          bool isSuccess = await _documentCapture.startUploadWithFiles(null);
                          if (isSuccess) {
                            Navigator.pushReplacementNamed(context, '/');
                          }
                        }
                      },
                      child: const Text("Confirm"),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
*/