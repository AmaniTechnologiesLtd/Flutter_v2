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

  // Shared step definition, reused for both platforms.
  List<SpeechVerifierStepConfiguration> get _steps => [
        SpeechVerifierStepConfiguration.identityQuestion(const [
          SpeechVerifierIdentityQuestionConfiguration(
            type: SpeechVerifierIdentityQuestionType.idNumber,
            matchThresholdPercent: 75,
          ),
        ]),
      ];

  static const _answers = SpeechVerifierIdentityAnswers(
    idNumber: "22180378472",
  );

  Future<void> _start() async {
    try {
      await _module.start(
        iosSettings: SpeechVerifierSettings(
          type: "XXX_ST_0",
          videoRecording: true,
          timeoutSeconds: 30,
          steps: _steps,
          identityAnswers: _answers,
          appearance: const SpeechVerifierAppearanceSettings(
            highlightedTextColor: "#34C759",
          ),
        ),
        androidSettings: AndroidSpeechVerifierSettings(
          type: "XXX_ST_0",
          serverURL: "https://dev.amani.ai",
          token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzg2NDAzMjI4LCJpYXQiOjE3ODYzOTk2MjcsImp0aSI6IjBkOTY5YzIwNWExYjQ1OWU4NTAzM2E5MjlmYTY0OWY4IiwidXNlcl9pZCI6IjM5ODQ4Yjc5LWM3NjItNGExNi1iMDFlLTdkYjlkMjJmNmNkNyIsImFwaV91c2VyIjpmYWxzZSwicHJvZmlsZV9pZCI6ImI1MTMwNDIzLWYyNmEtNGQ4NS05Y2UxLTYwNGI1OGMxOWIyMCIsImNvbXBhbnlfaWQiOiJmMTFjMDA3Yy0yMDU5LTRmNTEtYjI5ZS1hNTQxZTJhNDMzODIifQ.HrUGU3_puYuYPlm4As8gbTre9AbVjIoXk_S1VR9dGbE",
          steps: _steps,
          identityAnswers: _answers,
          matchThresholdPercent: 75,
        ),
      );

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