class AndroidAutoSelfieSettings {
  int? textSize;
  bool? counterVisible;
  int? counterTextSize;
  int? manualCropTimeout;
  String? distanceText;
  String? faceNotFoundText;
  String? stableText;
  String? restartText;

  AndroidAutoSelfieSettings(
      {this.textSize,
      this.counterVisible,
      this.counterTextSize,
      this.manualCropTimeout,
      this.distanceText,
      this.faceNotFoundText,
      this.stableText,
      this.restartText});

  Map toJson() {
    return {
      "textSize": textSize,
      "counterVisible": counterVisible,
      "counterTextSize": counterTextSize,
      "manualCropTimeout": manualCropTimeout,
      "distanceText": distanceText,
      "faceNotFoundText": faceNotFoundText,
      "stableText": stableText,
      "restartText": restartText
    };
  }
}
