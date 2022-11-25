package ai.amani.flutter_amanisdk_v2.modules

import ai.amani.flutter_amanisdk_v2.R
import ai.amani.flutter_amanisdk_v2.modules.config_models.AutoSelfieSettings
import ai.amani.flutter_amanisdk_v2.modules.config_models.PoseEstimationSettings
import ai.amani.sdk.Amani
import ai.amani.sdk.interfaces.AutoSelfieCaptureObserver
import ai.amani.sdk.interfaces.BioLoginUploadCallBack
import ai.amani.sdk.interfaces.ManualSelfieCaptureObserver
import ai.amani.sdk.modules.selfie.pose_estimation.observable.OnFailurePoseEstimation
import ai.amani.sdk.modules.selfie.pose_estimation.observable.PoseEstimationObserver
import android.app.Activity
import android.graphics.Bitmap
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import datamanager.model.customer.Errors
import io.flutter.plugin.common.MethodChannel
import java.nio.ByteBuffer

class BioLogin {
    private val bioLogin = Amani.sharedInstance().BioLogin()
    private var docType: String = "XXX_SE_0"
    private var frag: Fragment? = null
    private var token: String? = null
    private var customerId: Int? = null
    companion object  {
        val instance = BioLogin()
    }


    fun initBioLogin(server: String, sharedSecret: String?, token: String, customerId: Int, activity: Activity, result: MethodChannel.Result) {
        Amani.initBio(activity, server, sharedSecret)
        this.token = token
        this.customerId = customerId
        result.success(null)
    }

    fun startWithAutoSelfie(settings: AutoSelfieSettings, activity: Activity, result: MethodChannel.Result) {
        if (customerId == null) {
            result.error("BioLogin", "You must call initBioLogin before you use this function", null)
        }
        (activity as FragmentActivity)
        val id = 0x123456
        val context = activity.applicationContext
        val viewParams = FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        val container = FrameLayout(context)
        container.id = id
        activity.addContentView(container, viewParams)

        frag = bioLogin.AutoSelfieCapture()
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
                ).observer(object : AutoSelfieCaptureObserver {
                    override fun cb(bitmap: Bitmap?) {
                        val allocate: ByteBuffer = ByteBuffer.allocate(bitmap!!.byteCount)
                        bitmap.copyPixelsToBuffer(allocate)
                        val array: ByteArray = allocate.array()
                        activity.supportFragmentManager.beginTransaction().remove(frag!!).commitAllowingStateLoss()
                        result.success(array)
                    }
                }).build()


        activity.supportFragmentManager.beginTransaction()
                .replace(id, frag!!)
                .commitAllowingStateLoss()
    }

    fun startWithPoseEstimation(settings: PoseEstimationSettings, activity: Activity, result: MethodChannel.Result) {
        if (customerId == null) {
            result.error("BioLogin", "You must call initBioLogin before you use this function", null)
        }
        (activity as FragmentActivity)
        val id = 0x123456
        val context = activity.applicationContext
        val viewParams = FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        val container = FrameLayout(context)
        container.id = id
        activity.addContentView(container, viewParams)
        
        frag = bioLogin.PoseEstimation()
                .requestedPoseNumber(settings.poseCount)
                .ovalViewAnimationDurationMilSec(settings.animationDuration)
                .userInterfaceColors(
                        appFontColor = R.color.pose_estimation_font,
                        ovalViewStartColor = R.color.pose_estimation_oval_view_start,
                        ovalViewSuccessColor =  R.color.pose_estimation_oval_view_success,
                        ovalViewErrorColor = R.color.pose_estimation_oval_view_error,
                        alertFontTitleColor = R.color.pose_estimation_alert_title,
                        alertFontDescriptionColor = R.color.pose_estimation_alert_description,
                        alertFontTryAgainColor = R.color.pose_estimation_alert_try_again,
                        alertBackgroundColor = R.color.pose_estimation_alert_background,
                ).userInterfaceTexts(
                        faceIsTooFarText = settings.faceIsTooFar,
                        faceNotInside = settings.faceNotInside,
                        faceNotStraightText = settings.faceNotStraight,
                        alertTitle = settings.alertTitle,
                        alertDescription = settings.alertDescription,
                        alertTryAgain = settings.alertTryAgain,
                        keepStraightText = settings.keepStraight,
                ).observer(object: PoseEstimationObserver {
                    override fun onError(error: Error) {
                        result.error("BioLogin-PoseEstimation", error.message, null)
                    }

                    override fun onFailure(reason: OnFailurePoseEstimation, currentAttempt: Int) {
                        result.error("BioLogin-PoseEstimation", reason.name, currentAttempt.toString())
                    }

                    override fun onSuccess(bitmap: Bitmap?) {
                        if(bitmap != null) {
                            val allocate: ByteBuffer = ByteBuffer.allocate(bitmap.byteCount)
                            bitmap.copyPixelsToBuffer(allocate)
                            result.success(allocate.array())
                        } else {
                            result.error("No bitmap", "No bitmap returned from the call", null)
                        }
                        activity.supportFragmentManager.beginTransaction().remove(frag!!).commitAllowingStateLoss()
                    }
                }).build()


        activity.supportFragmentManager.beginTransaction()
                .replace(id, frag!!)
                .commitAllowingStateLoss()
    }

    fun startWithManualSelfie(selfieDescriptionText: String, activity: Activity, result: MethodChannel.Result) {
        if (customerId == null) {
            result.error("BioLogin", "You must call initBioLogin before you do this operation", null)
        }
        (activity as FragmentActivity)
        val id = 0x123456
        val context = activity.applicationContext
        val viewParams = FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        val container = FrameLayout(context)
        container.id = id
        activity.addContentView(container, viewParams)

        frag = bioLogin.ManualSelfieCapture()
                .userInterfaceColors(
                   appFontColor = R.color.biologin_manual_selfie_font,
                   manualButtonColor = R.color.biologin_manual_selfie_button,
                   ovalViewColor = R.color.biologin_manual_selfie_oval_view,
                   appBackgroundColor = R.color.biologin_manual_selfie_background
                ).userInterfaceTexts(
                        selfieDescriptionText = selfieDescriptionText
                ).observer(object : ManualSelfieCaptureObserver {
                    override fun cb(bitmap: Bitmap?) {
                        if(bitmap != null) {
                            val allocate: ByteBuffer = ByteBuffer.allocate(bitmap.byteCount)
                            bitmap.copyPixelsToBuffer(allocate)
                            result.success(allocate.array())
                            activity.supportFragmentManager.beginTransaction().remove(frag!!).commitAllowingStateLoss()
                        } else {
                            result.error("No bitmap", "No bitmap returned from the call", null)
                        }
                    }
                }).build()

        activity.supportFragmentManager.beginTransaction()
                .replace(id, frag!!)
                .commitAllowingStateLoss()
    }


    fun upload(completion: MethodChannel.Result) {
        if (customerId == null) {
            completion.error("BioLogin", "You must call initBioLogin before you do this operation", null)
        }
        bioLogin.upload(docType, token!!, customerId!!, object : BioLoginUploadCallBack {
            override fun cb(result: Boolean?, errors: Errors?) {
                if (result != null) {
                    completion.success(result)
                } else if(errors != null) {
                    completion.error("BioLogin Upload error", errors.errorMessage, null)
                }
            }
        })
    }

}