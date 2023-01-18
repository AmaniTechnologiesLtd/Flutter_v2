package ai.amani.flutter_amanisdk_v2.modules

import ai.amani.sdk.Amani
import android.app.Activity
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class Selfie: Module {
    private val selfieModule = Amani.sharedInstance().Selfie()
    private var docType: String? = "XXX_SE_0"
    private var frag: Fragment? = null

    companion object {
        val instance = Selfie()
    }


    override fun start(stepID: Int, activity: Activity, result: MethodChannel.Result) {
        (activity as FragmentActivity)
        val id = 0x123456
        val context = activity.applicationContext
        val viewParams = FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        val container = FrameLayout(context)
        container.id = id
        activity.addContentView(container, viewParams)

        frag = selfieModule.start(docType) { bitmap, _, file ->
            if (bitmap != null) {
                val stream = ByteArrayOutputStream()
                bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream)
                result.success(stream.toByteArray())
                activity.supportFragmentManager
                        .beginTransaction()
                        .remove(frag!!).commit()
            }
        }

        activity.supportFragmentManager
            .beginTransaction()
            .replace(id, frag!!)
            .commit()
    }

    override fun upload(activity: Activity, result: MethodChannel.Result) {
        try {
        selfieModule.upload((activity as FragmentActivity), docType) { isSuccess, uploadRes, errors ->
            if (isSuccess && uploadRes == "OK") {
                result.success(true)
            } else if (!errors.isNullOrEmpty()) {
                result.error("1006", "Upload Error", errors[0].errorMessage)
            } else {
                result.success(false)
            }
        }} catch (e: Exception) {}
    }

    override fun setType(type: String?, result: MethodChannel.Result) {
        this.docType = type
        result.success(null)
    }

}