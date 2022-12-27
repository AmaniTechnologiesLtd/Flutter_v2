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
            when {
                file != null -> {
                    val fileBitmap = BitmapFactory.decodeFile(file.absolutePath)
                    val stream = ByteArrayOutputStream()
                    fileBitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream)
                    result.success(stream.toByteArray())
                }
                bitmap != null -> {
                    val stream = ByteArrayOutputStream()
                    bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream)
                    result.success(stream.toByteArray())
                }
                else -> {
                    result.error("1006", "Nothing returned from selfie.start", null)
                }
            }
            activity.supportFragmentManager.beginTransaction().remove(frag!!).commitAllowingStateLoss()
        }

        val fragmentManager = activity.supportFragmentManager
            fragmentManager.beginTransaction()
                .replace(id, frag!!)
                .commitAllowingStateLoss()
    }

    override fun upload(activity: Activity, result: MethodChannel.Result) {
        selfieModule.upload((activity as FragmentActivity), docType) { isSuccess, uploadRes, errors ->
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
        this.docType = type
        result.success(null)
    }

}