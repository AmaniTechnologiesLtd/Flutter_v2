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
import java.nio.ByteBuffer

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
                    val buffer = ByteBuffer.allocate(bitmap.byteCount)
                    bitmap.copyPixelsToBuffer(buffer)
                    val array: ByteArray = buffer.array()
                    result.success(array)
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
                R.color.pose_estimation_oval_view_start,
                R.color.pose_estimation_oval_view_success,
                R.color.pose_estimation_oval_view_error,
                R.color.pose_estimation_alert_title,
                R.color.pose_estimation_alert_description,
                R.color.pose_estimation_alert_try_again,
                R.color.pose_estimation_alert_background,
                R.color.pose_estimation_font,
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

    override fun upload(useLocation: Boolean, activity: Activity, result: MethodChannel.Result) {
        poseEstimationModule.upload(activity!!, docType) { isSuccess, s, _ ->
            if (isSuccess != null) {
                result.success(isSuccess)
            } else {
                result.error("1006", "Upload failure", null)
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