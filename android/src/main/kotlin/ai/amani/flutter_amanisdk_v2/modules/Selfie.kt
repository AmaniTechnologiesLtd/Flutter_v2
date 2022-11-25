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
import java.io.File
import java.nio.ByteBuffer

class Selfie: Module {
    private val selfieModule = Amani.sharedInstance().Selfie()
    private var docType: String? = null
    private var frag: Fragment? = null

    companion object {
        val instance = Selfie()
    }


    override fun start(stepID: Int, activity: Activity, result: MethodChannel.Result) {
        if(docType == null) {
            result.error("1005", "Type not set.", "You have to call setType on idCapture before calling this method.")
            return
        }

        (activity as FragmentActivity)
        var id = 0x123456
        var context = activity.applicationContext
        var viewParams = FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        var container = FrameLayout(context)
        container.id = id
        activity.addContentView(container, viewParams)

        frag = selfieModule.start(docType) { bitmap, isDestroyed, file ->
            if (file != null) {
                Log.d("AmaniSDK-FILE", "file found")
                var fileBitmap = BitmapFactory.decodeFile(file.absolutePath)
                var allocate: ByteBuffer = ByteBuffer.allocate(fileBitmap.byteCount)
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
                result.error("1006", "Nothing returned from selfie.start", null)
            }
            activity.supportFragmentManager.beginTransaction().remove(frag!!).commitAllowingStateLoss()
        }


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