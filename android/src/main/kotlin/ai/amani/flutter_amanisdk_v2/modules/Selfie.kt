package ai.amani.flutter_amanisdk_v2.modules

import ai.amani.sdk.Amani
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
import java.io.File
import java.nio.ByteBuffer

class Selfie: Module {
    private val selfieModule = Amani.sharedInstance().Selfie()
    private var docType: String? = "XXX_SE_0"
    private var frag: Fragment? = null

    companion object {
        val instance = Selfie()
    }


    override fun start(stepID: Int, activity: Activity, result: MethodChannel.Result) {
        (activity as FragmentActivity)
        var id = 0x123456
        var context = activity.applicationContext
        var viewParams = FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        var container = FrameLayout(context)
        container.id = id
        activity.addContentView(container, viewParams)

        frag = selfieModule.start(docType) { bitmap, _, file ->
            when {
                file != null -> {
                    var fileBitmap = BitmapFactory.decodeFile(file.absolutePath)
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
        selfieModule.upload((activity as FragmentActivity), docType) { isSuccess, s, _ ->
            if(isSuccess != null) {
                result.success(isSuccess)
            } else {
                result.error("1006", "Upload failure", s)
            }
        }
    }

    override fun setType(type: String?, result: MethodChannel.Result) {
        this.docType = type
        result.success(null)
    }

}