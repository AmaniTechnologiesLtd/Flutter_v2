package ai.amani.flutter_amanisdk_v2.modules.config_models

import ai.amani.flutter_amanisdk_v2.modules.JSONConvertable
import kotlinx.parcelize.Parcelize

@Parcelize
data class AutoSelfieSettings(val textSize: Int,
                         val counterVisible: Boolean,
                         val counterTextSize: Int,
                         val manualCaptureTimeout: Int,
                         val distanceText: String,
                         val faceNotFoundText: String,
                         val stableText: String,
                         val restartText: String): JSONConvertable