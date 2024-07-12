
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_amanisdk/amani_sdk.dart';
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
