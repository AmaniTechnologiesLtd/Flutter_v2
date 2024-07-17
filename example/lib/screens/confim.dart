import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
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
  // Modules.
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

Future <String?> startMrzRequest() async {
 final String? mrzDocId = await _idCapture.getMrzRequest();
 return mrzDocId;
}



@override
  void initState() {
    super.initState();
    if (mrzReqCount < 1) {
       print("mrz reqCount kontrolü -----  $mrzReqCount");
       _isLoading = false;
      startMrzRequest().then((mrzDocumentId) {
          mrzDocId = mrzDocumentId;
          mrzReqCount += 1;
          _startListening();
          print("ilk mrz count değeri arttırıldı. $mrzReqCount");
      });
    } else {
      if (mrzReqCount >= 2) {
        mrzReqCount = 0;
         print(" mrz count değeri sıfırlandı. $mrzReqCount");
      }
      
    }
  }

   void _startListening() {
    _eventSubscription = eventChannel.receiveBroadcastStream().listen(
      _onEvent,
      onError: _onError,
    );
  }

  void _stopListening() {
    _eventSubscription?.cancel();
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

void _onEvent(dynamic event) {
    setState(() {
      if (event['type'] == 'mrzInfoDelegate') {
        if (event['data'] is String) {
          _processAndStartNFC(event['data']);
        }
      } else if (event['type'] == 'error') {
        _error = "Hata: ${event['data']['error_message']}";
      }
    });
  }

  void _onError(Object error) {
    setState(() {
      _error = "Error: $error";
    });
  }
  Future<void> _routeNextScreen(ConfirmArguments args, bool isDone) async {
    print("bir sonraki sayfaya ilerleyecek navigator çalışacak ---- CONFIRMENT ARGS:  $args, BOOLEAN DEGERI $isDone");
    if (isDone) {
         Navigator.pushNamed(context, ConfirmScreenState.routeName,
         arguments: ConfirmArguments(
         source: "idCapture",
         imageData: args.imageData,
         idCaptureBothSidesTaken: true,
         idCaptureNFCCompleted: true));
    } else {
      print("bir sonraki sayfaya ilerleyemedi ---- CONFIRMENT ARGS:  $args");
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
                          if (mrzDocId != null && mrzResult.isEmpty != true) {
                            setState(() {
                               _isLoading = false;
                             });
                           bool isDone = await _idCapture.iosStartNFC(mrzDocId, mrzResult);
                            print("CONFIRM EKRANINDA ISDONE DEGERI 1: $isDone");
                            _routeNextScreen(args, isDone);
                              
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
                          if (mrzDocId != null && mrzResult.isEmpty != true) {
                               bool isDone = await _idCapture.iosStartNFC(mrzDocId, mrzResult);
                                print("CONFIRM EKRANINDA ISDONE DEGERI 1: $isDone");
                                _routeNextScreen(args, isDone);
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
  StreamSubscription<dynamic>? _eventSubscription;

  final _idCapture = AmaniSDK().getIDCapture();
  final _autoSelfie = AmaniSDK().getAutoSelfie();
  final _selfie = AmaniSDK().getSelfie();
  final _poseEstimation = AmaniSDK().getPoseEstimation();
  final _documentCapture = AmaniSDK().getDocumentCapture();

  Map<String, dynamic> mrzResult = {};
  String mrzDocumentId = "";
  String _error = "No Error";
  bool _isLoading = false;

  

  Future<String?> startMrzRequest() async {
    print("CONFIRM EKRANINDA STARTMRZ FONKSİYONA GİRDİ -----");
    final String? mrzDocId = await _idCapture.getMrzRequest();
    setState(() {
      mrzDocumentId = mrzDocId ?? "";
    });
    return mrzDocId;
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
        _isLoading = false; // Stop the spinner
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
  void initState() {
    super.initState();
    startMrzRequest();
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

  void _stopListening() {
    _eventSubscription?.cancel();
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
          ? Center(child: CircularProgressIndicator())
          : Column(
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
                            

                            await startListeningForMrzResult().whenComplete(() {
                                  if (mrzDocumentId != null && mrzResult.isEmpty != true) {
                                _isLoading = false;
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
                            });
                            
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
                              await startListeningForMrzResult().whenComplete(() {
                               
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
                            });
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