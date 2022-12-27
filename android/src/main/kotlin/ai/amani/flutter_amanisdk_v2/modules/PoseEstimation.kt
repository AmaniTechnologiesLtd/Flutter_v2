package ai.amani.flutter_amanisdk_v2.modules

import ai.amani.flutter_amanisdk_v2.R
import ai.amani.flutter_amanisdk_v2.modules.config_models.PoseEstimationSettings
import ai.amani.sdk.Amani
import ai.amani.sdk.modules.selfie.pose_estimation.observable.OnFailurePoseEstimation
import ai.amani.sdk.modules.selfie.pose_estimation.observable.PoseEstimationObserver
import android.app.Activity
import android.graphics.Bitmap
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class PoseEstimation: Module {
    private val poseEstimationModule = Amani.sharedInstance().SelfiePoseEstimation()
    private var docType: String = "XXX_SE_0"
    private var frag: Fragment? = null

    private var settings: PoseEstimationSettings? = null

    companion object {
        val instance = PoseEstimation()
    }

    override fun start(stepID: Int, activity: Activity, result: MethodChannel.Result) {
        if (settings == null) {
            result.error("1005", "Settings not set", null)
        }

        val observer: PoseEstimationObserver = object : PoseEstimationObserver {
            override fun onError(error: Error) {
                (activity as FragmentActivity).supportFragmentManager.
                beginTransaction().remove(frag!!).commitAllowingStateLoss()
                result.error("1009", error.message, null)
            }

            override fun onFailure(reason: OnFailurePoseEstimation, currentAttempt: Int) {
                (activity as FragmentActivity).supportFragmentManager.
                beginTransaction().remove(frag!!).commitAllowingStateLoss()
                result.error(reason.code.toString(), reason.name, null)
            }

            override fun onSuccess(bitmap: Bitmap?) {
                (activity as FragmentActivity).supportFragmentManager.
                beginTransaction().remove(frag!!).commitAllowingStateLoss()
                if (bitmap != null) {
                   val stream = ByteArrayOutputStream()
                    bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream)
                    result.success(stream.toByteArray())
                } else {
                    result.error("1006", "Nothing returned from poseEstimation.start", null)
                }
            }

        }

        frag = poseEstimationModule.requestedPoseNumber(settings!!.poseCount)
                .ovalViewAnimationDurationMilSec(settings!!.animationDuration)
                .userInterfaceTexts(
                settings!!.faceNotInside,
                settings!!.faceNotStraight,
                settings!!.faceIsTooFar,
                settings!!.keepStraight,
                settings!!.alertTitle,
                settings!!.alertDescription,
                settings!!.alertTryAgain
        ).userInterfaceColors(
                ovalViewStartColor = R.color.pose_estimation_oval_view_start,
                ovalViewSuccessColor = R.color.pose_estimation_oval_view_success,
                ovalViewErrorColor =  R.color.pose_estimation_oval_view_error,
                alertTitleFontColor = R.color.pose_estimation_alert_title,
                alertDescriptionFontColor = R.color.pose_estimation_alert_description,
                alertTryAgainFontColor = R.color.pose_estimation_alert_try_again,
                alertBackgroundFontColor = R.color.pose_estimation_alert_background,
                appFontColor =  R.color.pose_estimation_font,
        ).observe(observer).build(activity)

        (activity as FragmentActivity)
        val id = 0x123456
        val context = activity.applicationContext
        val viewParams = FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        val container = FrameLayout(context)
        container.id = id
        activity.addContentView(container, viewParams)

        activity.supportFragmentManager.beginTransaction()
                .replace(id, frag!!)
                .commitAllowingStateLoss()
    }

    override fun upload(activity: Activity, result: MethodChannel.Result) {
        poseEstimationModule.upload(activity, docType) { isSuccess, uploadRes, errors ->
            if (isSuccess && uploadRes == "OK") {
                result.success(true)
            } else if (isSuccess && uploadRes == "ERROR") {
                result.error("1007", "Validation Errors", errors)
            } else if (!isSuccess && uploadRes == null && errors != null) {
                result.error("1006", "Upload Error", errors)
            }
        }
    }

    override fun setType(type: String?, result: MethodChannel.Result) {
        if (type != null) {
            this.docType = type
            result.success(null)
        }
    }

    fun setSettings(poseEstimationSettings: PoseEstimationSettings) {
        this.settings = poseEstimationSettings
    }

}