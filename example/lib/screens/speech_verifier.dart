import 'package:flutter/material.dart';
import 'package:flutter_amanisdk/amani_sdk.dart';
import 'package:flutter_amanisdk/common/models/speech_verifier_settings.dart';
import 'package:flutter_amanisdk/modules/speech_verifier.dart';

class SpeechVerifierScreen extends StatefulWidget {
  const SpeechVerifierScreen({Key? key}) : super(key: key);

  @override
  State<SpeechVerifierScreen> createState() => _SpeechVerifierScreenState();
}

class _SpeechVerifierScreenState extends State<SpeechVerifierScreen> {
  final SpeechVerifier _module = AmaniSDK().getSpeechVerifier();
  String? _status;

  Future<void> _start() async {
    final settings = SpeechVerifierSettings(
      type: "XXX_ST_0",
      videoRecording: true,
      timeoutSeconds: 30,
      steps: [
        // SpeechVerifierStepConfiguration.spokenText(const [
        //   SpeechVerifierTextConfiguration(
        //     text: "Kimliğimi doğrulamak için bu metni okuyorum.",
        //     matchThresholdPercent: 85,
        //   ),
        // ]),
        SpeechVerifierStepConfiguration.identityQuestion(const [
          SpeechVerifierIdentityQuestionConfiguration(
            type: SpeechVerifierIdentityQuestionType.idNumber,
            matchThresholdPercent: 75,
          ),
        ]),
        // SpeechVerifierStepConfiguration.identityQuestion(const [
        //   SpeechVerifierIdentityQuestionConfiguration(
        //     type: SpeechVerifierIdentityQuestionType.motherName,
        //     matchThresholdPercent: 90,
        //   ),
        // ]),
      ],
      identityAnswers: const SpeechVerifierIdentityAnswers(
        idNumber: "IDNumber",
        // motherName: "MotherName",
        // fatherName: "FatherName",
        // documentNumber: "DocumentNumber",
      ),
      appearance: const SpeechVerifierAppearanceSettings(
        highlightedTextColor: "#34C759",
      ),
    );

    try {
      
      await _module.start(settings);
      final uploaded = await _module.upload();
      if (!mounted) return;
      setState(() => _status = uploaded ? "Upload succeeded" : "Upload failed");
    } catch (e) {
      if (!mounted) return;
      setState(() => _status = "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Speech Verifier'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_status != null) Text(_status!),
            OutlinedButton(
              onPressed: _start,
              child: const Text("Start"),
            ),
          ],
        ),
      ),
    );
  }
}