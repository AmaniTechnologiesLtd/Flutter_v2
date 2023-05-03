package ai.amani.flutter_amanisdk_v2.modules

import ai.amani.sdk.Amani
import ai.amani.sdk.model.mrz.MRZResult
import android.app.Activity
import android.graphics.Bitmap
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import datamanager.model.customer.Errors
import io.flutter.Log
import io.flutter.plugin.common.MethodChannel.Result
import java.io.ByteArrayOutputStream


class IdCapture : Module {
    private var idCaptureModule = Amani.sharedInstance().IDCapture()
    private var docType: String? = null
    private var frag: Fragment? = null
    var usesNFC = false

    companion object {
        val instance = IdCapture()
    }
    override fun start(stepID: Int, activity: Activity, result: Result) {
        if(docType == null) {
            result.error("1005", "Type not set.", "You have to call setType on idCapture before calling this method.")
            return
        }

        val side: Boolean = stepID == 0

        (activity as FragmentActivity)
        val id = 0x123456
        val context = activity.applicationContext
        val viewParams = FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        val container = FrameLayout(context)
        container.id = id
        activity.addContentView(container, viewParams)

        frag = idCaptureModule.start(activity, container, docType!!, side) { bitmap, _, file ->
            Log.d("IDCapture", "CALLBACK TRIGGERED")
            if (bitmap != null) {
                Log.d("IDCapture", "BITMAP FOUND RETURNING")
                val stream = ByteArrayOutputStream()
                bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream)
                result.success(stream.toByteArray())
                activity.supportFragmentManager.beginTransaction().remove(frag!!).commit()
            }
        }

        if (frag == null) {
            result.error("20900", "Failed to initialize ID Capture", null)
            return
        }

        val fragmentManager = activity.supportFragmentManager
        fragmentManager.beginTransaction()
                .replace(id, frag!!)
                .commit()
    }

    fun setWithNFC(usesNFC: Boolean = false) {
        this.usesNFC = usesNFC
        idCaptureModule.withNFC(usesNFC)
    }

    fun setManualCaptureButtonTimeout(timeout: Int) {
        idCaptureModule.setManualCropTimeOut(timeout);
    }

    fun getMRZ(onComplete: (MRZResult) -> Unit,  onError: (Errors) -> Unit  ) {
        Amani.sharedInstance().IDCapture().getMRZ(type = docType!!, onComplete = onComplete, onError = onError)
    }

    override fun upload(activity: Activity, result : Result) {
        try {
            idCaptureModule.upload(activity as FragmentActivity, docType!!) { isSuccess, uploadRes, errors ->
                if (isSuccess && uploadRes == "OK") {
                    result.success(true)
                } else if (!errors.isNullOrEmpty()) {
                    result.error("1006", "Upload Error", errors[0].errorMessage)
                } else {
                    result.success(false)
                }
            }} catch (e: Exception) {}
    }

    override fun setType(type: String?, result: Result) {
        this.docType = type
        Log.d("AmaniSDK", "setTypeCalled!")
        result.success(null)
    }

}