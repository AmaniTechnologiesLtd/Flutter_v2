import 'dart:typed_data';

import 'package:flutter_amanisdk/common/models/file_type.dart';
import 'package:flutter_amanisdk/flutter_amanisdk_method_channel.dart';

class DocumentCapture {
  final MethodChannelAmaniSDK _methodChannel;

  DocumentCapture(this._methodChannel);

  Future<Uint8List> start({int documentCount = 1}) async {
    if (documentCount < 0) {
      throw Exception(
          'Document count cannot be negative, are you sure you want to use this method?');
    }

    try {
      final imageData =
          await _methodChannel.startDocumentCaptureWithView(documentCount);
      if (imageData != null) {
        return imageData;
      } else {
        throw Exception('[AmaniSDK] No image returned from document capture');
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> startUploadWithFiles(List<FileTypeModel>? files) async {
    List<Map<String, dynamic>>? fileList;

    if (files != null) {
      fileList = files.map((element) {
        return element.toMap();
      }).toList();
    }

    try {
      final uploadState = await _methodChannel.documentCaptureUpload(fileList);
      if (uploadState == true) {
        return uploadState;
      } else {
        return false;
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> setType(String type) async {
    try {
      await _methodChannel.documentCaptureSetType(type);
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> androidBackButtonHandler() async {
    try {
      final res = await _methodChannel.androidDocumentCaptureBackPressHandle();
      return res;
    } catch (err) {
      rethrow;
    }
  }
}
