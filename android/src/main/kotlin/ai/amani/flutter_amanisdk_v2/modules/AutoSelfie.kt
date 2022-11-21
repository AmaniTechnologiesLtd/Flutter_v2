package ai.amani.flutter_amanisdk_v2.modules

import ai.amani.flutter_amanisdk_v2.R
import ai.amani.flutter_amanisdk_v2.modules.config_models.AutoSelfieSettings
import ai.amani.sdk.Amani
import ai.amani.sdk.modules.selfie.auto_capture.ASCBuilder
import android.app.Activity
import android.graphics.BitmapFactory
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import io.flutter.Log
import io.flutter.plugin.common.MethodChannel
import java.nio.ByteBuffer

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
            if (file != null) {
                Log.d("AmaniSDK-FILE", "file found")
                val fileBitmap = BitmapFactory.decodeFile(file.absolutePath)
                val allocate: ByteBuffer = ByteBuffer.allocate(fileBitmap.byteCount)
                fileBitmap.copyPixelsToBuffer(allocate)
                val array: ByteArray = allocate.array()
                result.success(array)
            } else if (bitmap != null) {
                Log.d("AmaniSDK-FILE", "byte[] found")
                val allocate: ByteBuffer = ByteBuffer.allocate(bitmap.byteCount)
                bitmap.copyPixelsToBuffer(allocate)
                val array: ByteArray = allocate.array()
                result.success(array)
            } else {
                result.error("1006", "Nothing returned from idCapture.start", null)
            }
            activity.supportFragmentManager.beginTransaction().remove(frag!!).commitAllowingStateLoss()
        }

        val fragmentManager = activity.supportFragmentManager
        fragmentManager.beginTransaction()
                .replace(id, frag!!)
                .commitAllowingStateLoss()
    }

    override fun upload(useLocation: Boolean, activity: Activity, result: MethodChannel.Result) {
        autoSelfieModule.upload((activity as FragmentActivity), docType!!) { isSuccess, s, _ ->
            if(isSuccess != null) {
                result.success(isSuccess)
            } else {
                result.error("1006", "Upload failure", s)
            }
        }
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