package ai.amani.flutter_amanisdk.modules

import ai.amani.flutter_amanisdk.R
import ai.amani.flutter_amanisdk.modules.config_models.AutoSelfieSettings
import ai.amani.flutter_amanisdk.modules.config_models.PoseEstimationSettings
import ai.amani.sdk.Amani
import ai.amani.sdk.interfaces.AutoSelfieCaptureObserver
import ai.amani.sdk.interfaces.BioLoginUploadCallBack
import ai.amani.sdk.interfaces.ManualSelfieCaptureObserver
import ai.amani.sdk.modules.selfie.pose_estimation.observable.OnFailurePoseEstimation
import ai.amani.sdk.modules.selfie.pose_estimation.observable.PoseEstimationObserver
import android.app.Activity
import android.graphics.Bitmap
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.FrameLayout
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class BioLogin {
    private var docType: String = "XXX_SE_0"
    private var frag: Fragment? = null
    private var token: String? = null
    private var customerId: Int? = null
    private var comparisonAdapter: Int = 2
    private var source: Int = 3
    private var attemptID: String? = null
    private var closeButton: Button? = null

    companion object  {
        val instance = BioLogin()
    }



    fun initBioLogin(server: String, sharedSecret: String?, token: String, customerId: Int, comparisonAdapter: Int?, source: Int?, attemptID: String, activity: Activity, result: MethodChannel.Result) {
        Amani.initBio(activity, server, sharedSecret)
        this.token = token
        this.customerId = customerId
        if (comparisonAdapter != null) {
            this.comparisonAdapter = comparisonAdapter
        }

        if (source != null) {
            this.source = source
        }
        this.attemptID = attemptID

        result.success(null)
    }

    fun startWithAutoSelfie(settings: AutoSelfieSettings, activity: Activity, result: MethodChannel.Result) {
        if (customerId == null && attemptID == null) {
            result.error("30003", "You must call initBioLogin before you use this function", null)
        }
        (activity as FragmentActivity)
        val id = 0x123456
        val context = activity.applicationContext
        val viewParams = FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        val container = FrameLayout(context)
        container.id = id
        activity.addContentView(container, viewParams)
        frag = Amani.sharedInstance().BioLogin().AutoSelfieCapture()
                .timeOutManualButton(settings.manualCaptureTimeout)
                .userInterfaceColors(
                        ovalViewStartColor = R.color.auto_selfie_oval_view,
                        ovalViewSuccessColor = R.color.auto_selfie_success_anim,
                        appFontColor = R.color.auto_selfie_text,
                        manualButtonColor = R.color.auto_selfie_counter_text,
                ).userInterfaceTexts(
                        faceIsTooFarText = settings.distanceText,
                        holdStableText = settings.stableText,
                        faceNotFoundText = settings.faceNotFoundText,
                ).configuration(
                        comparisonAdapter = this.comparisonAdapter,
                        source = this.source,
                        attemptId = this.attemptID!!
                ).observer(object : AutoSelfieCaptureObserver {
                    override fun cb(bitmap: Bitmap?) {
                        if(bitmap != null) {
                            val stream = ByteArrayOutputStream()
                            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream)
                            result.success(stream.toByteArray())
                        }

                        closeButton!!.visibility = View.GONE
                        activity.supportFragmentManager.beginTransaction().remove(frag!!).commitAllowingStateLoss()
                        frag = null
                    }
                }).build()

        this.closeButton = container.setupBackButton(R.drawable.baseline_close_24, onClick = {
            activity.supportFragmentManager.beginTransaction().remove(frag!!).commit()
            frag = null
        })

        activity.supportFragmentManager.beginTransaction()
                .replace(id, frag!!)
                .commitAllowingStateLoss()
    }

    fun startWithPoseEstimation(settings: PoseEstimationSettings, activity: Activity, result: MethodChannel.Result, channel: MethodChannel) {
        if (customerId == null && attemptID == null) {
            result.error("30003", "You must call initBioLogin before you use this function", null)
        }
        (activity as FragmentActivity)
        val id = 0x123456
        val context = activity.applicationContext
        val viewParams = FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        val container = FrameLayout(context)
        container.id = id
        activity.addContentView(container, viewParams)
        
        frag = Amani.sharedInstance().BioLogin().PoseEstimation()
                .requestedPoseNumber(settings.poseCount)
                .ovalViewAnimationDurationMilSec(settings.animationDuration)
                .configuration(
                        comparisonAdapter = this.comparisonAdapter,
                        source = this.source,
                        attemptId = this.attemptID!!
                )
                .userInterfaceColors(
                        ovalViewStartColor = R.color.pose_estimation_oval_view_start,
                        ovalViewSuccessColor = R.color.pose_estimation_oval_view_success,
                        ovalViewErrorColor =  R.color.pose_estimation_oval_view_error,
                        alertTitleFontColor = R.color.pose_estimation_alert_title,
                        alertDescriptionFontColor = R.color.pose_estimation_alert_description,
                        alertTryAgainFontColor = R.color.pose_estimation_alert_try_again,
                        alertBackgroundFontColor = R.color.pose_estimation_alert_background,
                        appFontColor =  R.color.pose_estimation_font,
                ).userInterfaceVisibilities(
                        settings.mainGuideVisibility,
                        settings.secondaryGuideVisibility
                ).userInterfaceDrawables(
                        R.drawable.pose_esitmation_main_guide_left,
                        R.drawable.pose_estimation_main_guide_right,
                        R.drawable.pose_estimation_main_guide_up,
                        R.drawable.pose_estimation_main_guide_down,
                        R.drawable.pose_estimation_main_guide_straight,
                        R.drawable.pose_estimation_secondary_guide_left,
                        R.drawable.pose_estimation_secondary_guide_right,
                        R.drawable.pose_estimation_secondary_guide_up,
                        R.drawable.pose_estimation_secondary_guide_down,
                ).userInterfaceTexts(
                        settings.faceNotInside,
                        settings.faceNotStraight,
                        settings.faceIsTooFar,
                        settings.holdPhoneVertically,
                        settings.alertTitle,
                        settings.alertDescription,
                        settings.alertTryAgain
                ).observer(object: PoseEstimationObserver {
                    override fun onError(error: Error) {
                        channel.invokeMethod("androidBioLoginPoseEstimation#onError", mapOf("message" to error.message))
                    }

                    override fun onFailure(reason: OnFailurePoseEstimation, currentAttempt: Int) {
                        channel.invokeMethod("androidBioLoginPoseEstimation#onFailure", mapOf("reason" to reason.name, "currentAttempt" to currentAttempt))
                    }

                    override fun onSuccess(bitmap: Bitmap?) {
                        if(bitmap != null) {
                            val stream = ByteArrayOutputStream()
                            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream)
                            channel.invokeMethod("androidBioLoginPoseEstimation#onSuccess", mapOf("image" to stream.toByteArray()))

                            activity.runOnUiThread {
                                closeButton!!.visibility = View.GONE
                            }

                            activity.supportFragmentManager.beginTransaction().remove(frag!!).commitAllowingStateLoss()
                            frag = null
                        }
                    }
                }).build()

        this.closeButton = container.setupBackButton(R.drawable.baseline_close_24, onClick = {
            activity.supportFragmentManager.beginTransaction().remove(frag!!).commit()
            frag = null
        })

        activity.supportFragmentManager.beginTransaction()
                .replace(id, frag!!)
                .commitAllowingStateLoss()
    }

    fun startWithManualSelfie(selfieDescriptionText: String, activity: Activity, result: MethodChannel.Result) {
        if (customerId == null && attemptID == null) {
            result.error("30003", "You must call initBioLogin before you do this operation", null)
        }
        (activity as FragmentActivity)
        val id = 0x123456
        val context = activity.applicationContext
        val viewParams = FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        val container = FrameLayout(context)
        container.id = id
        activity.addContentView(container, viewParams)

        frag = Amani.sharedInstance().BioLogin().ManualSelfieCapture()
                .userInterfaceColors(
                   appFontColor = R.color.biologin_manual_selfie_font,
                   manualButtonColor = R.color.biologin_manual_selfie_button,
                   ovalViewColor = R.color.biologin_manual_selfie_oval_view,
                   appBackgroundColor = R.color.biologin_manual_selfie_background
                ).userInterfaceTexts(
                        selfieDescriptionText = selfieDescriptionText
                ).configuration(
                        comparisonAdapter = this.comparisonAdapter,
                        source = this.source,
                        attemptId = this.attemptID!!
                )
                .observer(object : ManualSelfieCaptureObserver {
                    override fun cb(bitmap: Bitmap?) {
                        if(bitmap != null) {
                            val stream = ByteArrayOutputStream()
                            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream)
                            result.success(stream.toByteArray())
                            activity.supportFragmentManager.beginTransaction().remove(frag!!).commit()
                            frag = null
                            activity.runOnUiThread {
                                closeButton!!.visibility = View.GONE
                            }

                        }
                    }
                }).build()

        this.closeButton = container.setupBackButton(R.drawable.baseline_close_24, onClick = {
            activity.supportFragmentManager.beginTransaction().remove(frag!!).commit()
            frag = null
        })

        activity.supportFragmentManager.beginTransaction()
                .replace(id, frag!!)
                .commit()
    }


    fun upload(completion: MethodChannel.Result) {
        if (customerId == null) {
            completion.error("30003", "You must call initBioLogin before you do this operation", null)
        }
        Amani.sharedInstance().BioLogin().upload(docType, token!!, customerId!!, object : BioLoginUploadCallBack {
            override fun cb(result: Boolean?) {
                result?.let {
                    completion.success(it);
                } ?: run{
                    completion.error("30012", "Upload exception", null)
                }
            }
        })
    }

    fun backPressHandle(activity: Activity, result: MethodChannel.Result) {
        if (frag == null){
            result.error("30001",
                    "You must call this function while the" +
                            "module is running", "You can ignore this message and return true" +
                    "from onWillPop()")
        } else {
            activity.runOnUiThread {
                frag?.let {
                    closeButton!!.visibility = View.GONE
                    it.parentFragmentManager.beginTransaction().remove(frag!!).commit()
                    frag = null
                    // This blocks the flutters back press action.
                    result.success(false)
                }
            }
        }
   }
}