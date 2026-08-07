import 'dart:typed_data';

import 'package:flutter_amanisdk/common/models/speech_verifier_settings.dart';
import 'package:flutter_amanisdk/flutter_amanisdk_method_channel.dart';

class SpeechVerifier {
  final MethodChannelAmaniSDK _methodChannel;

  SpeechVerifier(this._methodChannel);

  /// Starts the speech verifier flow. Returns the captured evidence image
  /// (black frame) as bytes when the flow completes successfully, mirroring
  /// the other capture modules.
  Future<Uint8List?> start(SpeechVerifierSettings settings) async {
    try {
      final dynamic imageData =
          await _methodChannel.startSpeechVerifier(settings.toJson());
      return imageData as Uint8List?;
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> upload() async {
    try {
      final bool isDone = await _methodChannel.uploadSpeechVerifier();
      return isDone;
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> androidBackButtonHandle() async {
    return await _methodChannel.androidSpeechVerifierBackPressHandle();
  }
}