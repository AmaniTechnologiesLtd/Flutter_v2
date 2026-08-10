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
// ── Android-specific settings ─────────────────────────────────────────────

/// Android continuation prompts (identity-question on-screen texts).
class SpeechVerifierContinuationPrompts {
  final String? instruction;
  final String? idNumber;
  final String? motherName;
  final String? fatherName;
  final String? documentNumber;

  const SpeechVerifierContinuationPrompts({
    this.instruction,
    this.idNumber,
    this.motherName,
    this.fatherName,
    this.documentNumber,
  });

  Map<String, dynamic> toMap() => {
        if (instruction != null) "instruction": instruction,
        if (idNumber != null) "idNumber": idNumber,
        if (motherName != null) "motherName": motherName,
        if (fatherName != null) "fatherName": fatherName,
        if (documentNumber != null) "documentNumber": documentNumber,
      };
}

/// Android UI color overrides (raw ARGB ints as hex strings, e.g. "#FF111111").
class SpeechVerifierAndroidColors {
  final String? speechTextColor;
  final String? micActiveColor;
  final String? retryButtonBackgroundColor;

  const SpeechVerifierAndroidColors({
    this.speechTextColor,
    this.micActiveColor,
    this.retryButtonBackgroundColor,
  });

  Map<String, dynamic> toMap() => {
        if (speechTextColor != null) "speechTextColor": speechTextColor,
        if (micActiveColor != null) "micActiveColor": micActiveColor,
        if (retryButtonBackgroundColor != null)
          "retryButtonBackgroundColor": retryButtonBackgroundColor,
      };
}

/// Android on-screen status text overrides.
class SpeechVerifierAndroidTexts {
  final String? listening;
  final String? verifying;
  final String? verified;
  final String? failed;
  final String? retry;

  const SpeechVerifierAndroidTexts({
    this.listening,
    this.verifying,
    this.verified,
    this.failed,
    this.retry,
  });

  Map<String, dynamic> toMap() => {
        if (listening != null) "listening": listening,
        if (verifying != null) "verifying": verifying,
        if (verified != null) "verified": verified,
        if (failed != null) "failed": failed,
        if (retry != null) "retry": retry,
      };
}

/// Full Android settings bundle. Android is self-contained and needs its own
/// [serverURL] + profile-scoped [token] for upload and identity-question fetch.
class AndroidSpeechVerifierSettings {
  final String type;

  /// Profile-scoped session (required for upload; required for identity
  /// questions when [identityAnswers] is not supplied).
  final String? serverURL;
  final String? token;

  final List<SpeechVerifierStepConfiguration> steps;
  final SpeechVerifierIdentityAnswers? identityAnswers;

  /// Applied when steps contain a single spoken-text with one threshold, or as
  /// a global default. 100 = exact.
  final int matchThresholdPercent;

  final bool autoDetectForeignWords;
  final bool detectTurkishNegation;
  final bool ignoreTurkishDiacritics;
  final List<String> rejectWords;
  final List<String> verificationExemptWords;
  final int timeoutMillis;
  final double bottomSheetCornerRadius;

  final SpeechVerifierContinuationPrompts? continuationPrompts;
  final SpeechVerifierAndroidColors? colors;
  final SpeechVerifierAndroidTexts? texts;

  const AndroidSpeechVerifierSettings({
    required this.type,
    required this.steps,
    this.serverURL,
    this.token,
    this.identityAnswers,
    this.matchThresholdPercent = 100,
    this.autoDetectForeignWords = true,
    this.detectTurkishNegation = true,
    this.ignoreTurkishDiacritics = false,
    this.rejectWords = const [],
    this.verificationExemptWords = const [],
    this.timeoutMillis = 60000,
    this.bottomSheetCornerRadius = 0.0,
    this.continuationPrompts,
    this.colors,
    this.texts,
  });

  Map<String, dynamic> toMap() => {
        "type": type,
        if (serverURL != null) "serverURL": serverURL,
        if (token != null) "token": token,
        "steps": steps.map((e) => e.toMap()).toList(),
        if (identityAnswers != null)
          "identityAnswers": identityAnswers!.toMap(),
        "matchThresholdPercent": matchThresholdPercent,
        "autoDetectForeignWords": autoDetectForeignWords,
        "detectTurkishNegation": detectTurkishNegation,
        "ignoreTurkishDiacritics": ignoreTurkishDiacritics,
        "rejectWords": rejectWords,
        "verificationExemptWords": verificationExemptWords,
        "timeoutMillis": timeoutMillis,
        "bottomSheetCornerRadius": bottomSheetCornerRadius,
        if (continuationPrompts != null)
          "continuationPrompts": continuationPrompts!.toMap(),
        if (colors != null) "colors": colors!.toMap(),
        if (texts != null) "texts": texts!.toMap(),
      };

  String toJson() => jsonEncode(toMap());
}