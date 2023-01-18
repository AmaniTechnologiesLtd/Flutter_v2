package ai.amani.flutter_amanisdk_v2.modules

import ai.amani.flutter_amanisdk_v2.R
import ai.amani.flutter_amanisdk_v2.modules.config_models.AutoSelfieSettings
import ai.amani.sdk.Amani
import ai.amani.sdk.modules.selfie.auto_capture.ASCBuilder
import android.app.Activity
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import io.flutter.Log
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class AutoSelfie: Module {
    private val autoSelfieModule = Amani.sharedInstance().AutoSelfieCapture()
    private var docType: String = "XXX_SE_0"
    private var frag: Fragment? = null

    private var settings: AutoSelfieSettings? = null

    companion object {
        val instance = AutoSelfie()
    }

    override fun start(stepID: Int, activity: Activity, result: MethodChannel.Result) {

        if(settings == null) {
            result.error("1005", "Settings not set", "You have to call setSettings before calling this method.")
            return
        }

        (activity as FragmentActivity)
        val id = 0x123456
        val context = activity.applicationContext
        val viewParams = FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        val container = FrameLayout(context)
        container.id = id
        activity.addContentView(container, viewParams)

        val ascBuilder = ASCBuilder(
            R.color.auto_selfie_text,
                settings!!.textSize,
                R.color.auto_selfie_counter_text,
                settings!!.counterVisible,
                settings!!.counterTextSize,
                settings!!.manualCaptureTimeout,
                settings!!.distanceText,
                settings!!.faceNotFoundText,
                settings!!.stableText,
                settings!!.restartText,
                R.color.auto_selfie_oval_view,
                R.color.auto_selfie_success_anim,
        )

        frag = autoSelfieModule.start(docType, ascBuilder, container) { bitmap, _, file ->
            if (bitmap != null) {
                val stream = ByteArrayOutputStream()
                bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream)
                result.success(stream.toByteArray())
                activity.supportFragmentManager.beginTransaction().remove(frag!!).commit()
            }
        }



        val fragmentManager = activity.supportFragmentManager
        fragmentManager.beginTransaction()
                .replace(id, frag!!)
                .commit()
    }

    override fun upload(activity: Activity, result: MethodChannel.Result) {
        try {
            autoSelfieModule.upload((activity as FragmentActivity), docType) { isSuccess, uploadRes, errors ->
                if (isSuccess && uploadRes == "OK") {
                    result.success(true)
                } else if (!errors.isNullOrEmpty()) {
                    result.error("1007", "Upload Error", errors[0].errorMessage)
                } else {
                    result.success(false)
                }
            }} catch (e: Exception) {}
    }

    override fun setType(type: String?, result: MethodChannel.Result) {
        if (type != null) {
            this.docType = type
            result.success(null)
        }
    }

    fun setSettings(settings: AutoSelfieSettings) {
        this.settings = settings
    }
}