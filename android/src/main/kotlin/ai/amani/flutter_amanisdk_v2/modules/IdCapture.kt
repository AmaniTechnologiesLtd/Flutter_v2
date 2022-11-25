package ai.amani.flutter_amanisdk_v2.modules

import ai.amani.sdk.Amani
import android.app.Activity
import android.graphics.BitmapFactory
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import io.flutter.Log
import io.flutter.plugin.common.MethodChannel.Result
import java.nio.ByteBuffer


class IdCapture : Module {
    private var idCaptureModule = Amani.sharedInstance().IDCapture()
    private var docType: String? = null
    private var frag: Fragment? = null

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
            when {
                file != null -> {
                    Log.d("AmaniSDK-FILE", "file found")
                    val fileBitmap = BitmapFactory.decodeFile(file.absolutePath)
                    val allocate: ByteBuffer = ByteBuffer.allocate(fileBitmap.byteCount)
                    fileBitmap.copyPixelsToBuffer(allocate)
                    val array: ByteArray = allocate.array()
                    result.success(array)
                }
                bitmap != null -> {
                    Log.d("AmaniSDK-FILE", "byte[] found")
                    val allocate: ByteBuffer = ByteBuffer.allocate(bitmap.byteCount)
                    bitmap.copyPixelsToBuffer(allocate)
                    val array: ByteArray = allocate.array()
                    result.success(array)
                }
                else -> {
                    result.error("1006", "Nothing returned from idCapture.start", null)
                }
            }
            activity.supportFragmentManager.beginTransaction().remove(frag!!).commitAllowingStateLoss()
        }

        val fragmentManager = activity.supportFragmentManager
        fragmentManager.beginTransaction()
                .replace(id, frag!!)
                .commitAllowingStateLoss()
    }

    override fun upload(activity: Activity, result : Result) {
        idCaptureModule.upload((activity as FragmentActivity), docType!!) { isSuccess, s, errors ->
            if (errors == null) {
                result.success(isSuccess)
            } else {
                result.error("1006", "Upload failure", s)
            }

        }
    }

    override fun setType(type: String?, result: Result) {
        this.docType = type
        Log.d("AmaniSDK", "setTypeCalled!")
        result.success(null)
    }

}