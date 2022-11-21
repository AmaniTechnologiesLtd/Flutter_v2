package ai.amani.flutter_amanisdk_v2.modules.config_models
import  ai.amani.flutter_amanisdk_v2.modules.JSONConvertable
import kotlinx.parcelize.Parcelize

@Parcelize
class PoseEstimationSettings(
                            val poseCount: Int,
                            val animationDuration: Int,
                            val faceNotInside: String,
                             val faceNotStraight: String,
                             val faceIsTooFar: String,
                             val keepStraight: String,
                             val alertTitle: String,
                             val alertDescription: String,
                             val alertTryAgain: String
): JSONConvertable