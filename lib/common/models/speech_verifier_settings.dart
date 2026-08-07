import 'dart:convert';

/// Match modes exposed by the Core SDK speech verifier.
enum SpeechVerifierIdentityQuestionType {
  idNumber,
  motherName,
  fatherName,
  documentNumber,
}

extension SpeechVerifierIdentityQuestionTypeX
    on SpeechVerifierIdentityQuestionType {
  String get raw {
    switch (this) {
      case SpeechVerifierIdentityQuestionType.idNumber:
        return "idNumber";
      case SpeechVerifierIdentityQuestionType.motherName:
        return "motherName";
      case SpeechVerifierIdentityQuestionType.fatherName:
        return "fatherName";
      case SpeechVerifierIdentityQuestionType.documentNumber:
        return "documentNumber";
    }
  }
}

/// A single spoken-text entry with its own threshold.
class SpeechVerifierTextConfiguration {
  final String text;
  final int matchThresholdPercent;

  const SpeechVerifierTextConfiguration({
    required this.text,
    this.matchThresholdPercent = 100,
  });

  Map<String, dynamic> toMap() => {
        "text": text,
        "matchThresholdPercent": matchThresholdPercent,
      };
}

/// A single identity-question entry with its own threshold.
class SpeechVerifierIdentityQuestionConfiguration {
  final SpeechVerifierIdentityQuestionType type;
  final int matchThresholdPercent;

  const SpeechVerifierIdentityQuestionConfiguration({
    required this.type,
    this.matchThresholdPercent = 100,
  });

  Map<String, dynamic> toMap() => {
        "type": type.raw,
        "matchThresholdPercent": matchThresholdPercent,
      };
}

/// One verification step. Exactly one of [spokenText] / [identityQuestion]
/// is populated, mirroring the Core SDK's `SpeechVerifierStepConfiguration`.
class SpeechVerifierStepConfiguration {
  final List<SpeechVerifierTextConfiguration>? spokenText;
  final List<SpeechVerifierIdentityQuestionConfiguration>? identityQuestion;

  const SpeechVerifierStepConfiguration._({
    this.spokenText,
    this.identityQuestion,
  });

  factory SpeechVerifierStepConfiguration.spokenText(
    List<SpeechVerifierTextConfiguration> texts,
  ) =>
      SpeechVerifierStepConfiguration._(spokenText: texts);

  factory SpeechVerifierStepConfiguration.identityQuestion(
    List<SpeechVerifierIdentityQuestionConfiguration> questions,
  ) =>
      SpeechVerifierStepConfiguration._(identityQuestion: questions);

  Map<String, dynamic> toMap() {
    if (spokenText != null) {
      return {
        "type": "spokenText",
        "items": spokenText!.map((e) => e.toMap()).toList(),
      };
    }
    return {
      "type": "identityQuestion",
      "items": identityQuestion!.map((e) => e.toMap()).toList(),
    };
  }
}

/// Manual identity answers, mirroring Core SDK's `identityAnswers(...)`.
class SpeechVerifierIdentityAnswers {
  final String? idNumber;
  final String? motherName;
  final String? fatherName;
  final String? documentNumber;

  const SpeechVerifierIdentityAnswers({
    this.idNumber,
    this.motherName,
    this.fatherName,
    this.documentNumber,
  });

  Map<String, dynamic> toMap() => {
        if (idNumber != null) "idNumber": idNumber,
        if (motherName != null) "motherName": motherName,
        if (fatherName != null) "fatherName": fatherName,
        if (documentNumber != null) "documentNumber": documentNumber,
      };
}

/// Optional appearance passthrough. Colors are hex strings (e.g. "#34C759").
class SpeechVerifierAppearanceSettings {
  final String? highlightedTextColor;

  const SpeechVerifierAppearanceSettings({this.highlightedTextColor});

  Map<String, dynamic> toMap() => {
        if (highlightedTextColor != null)
          "highlightedTextColor": highlightedTextColor,
      };
}

/// Full settings bundle passed to the native side as a JSON string.
class SpeechVerifierSettings {
  final String type;
  final bool videoRecording;
  final int timeoutSeconds;
  final List<SpeechVerifierStepConfiguration> steps;
  final SpeechVerifierIdentityAnswers? identityAnswers;
  final SpeechVerifierAppearanceSettings? appearance;

  const SpeechVerifierSettings({
    required this.type,
    required this.steps,
    this.videoRecording = true,
    this.timeoutSeconds = 30,
    this.identityAnswers,
    this.appearance,
  });

  Map<String, dynamic> toMap() => {
        "type": type,
        "videoRecording": videoRecording,
        "timeoutSeconds": timeoutSeconds,
        "steps": steps.map((e) => e.toMap()).toList(),
        if (identityAnswers != null)
          "identityAnswers": identityAnswers!.toMap(),
        if (appearance != null) "appearance": appearance!.toMap(),
      };

  String toJson() => jsonEncode(toMap());
}