package ai.amani.flutter_amanisdk_v2.modules

import ai.amani.flutter_amanisdk_v2.R
import ai.amani.sdk.Amani
import android.app.Activity
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.FrameLayout
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class Selfie: Module {
    private val selfieModule = Amani.sharedInstance().Selfie()
    private var docType: String = "XXX_SE_0"
    private var frag: Fragment? = null
    private var closeButton: Button? = null
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

                activity.runOnUiThread {
                    closeButton!!.visibility = View.GONE
                }
            }
        }

        closeButton = container.setupBackButton(R.drawable.baseline_close_24, onClick = {
            activity.supportFragmentManager.beginTransaction().remove(frag!!).commit()
        })

        activity.supportFragmentManager
            .beginTransaction()
            .replace(id, frag!!)
            .commit()
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

    override fun upload(activity: Activity, result: MethodChannel.Result) {
        try {
            selfieModule.upload((activity as FragmentActivity), docType) { isSuccess, uploadRes, errors ->
                if (isSuccess && uploadRes == "OK") {
                    result.success(true)
                } else if (!errors.isNullOrEmpty()) {
                    val errorDict = errors.associate {
                        "error_code" to it.errorCode
                        "error_message" to it.errorMessage
                    }
                    result.error("30010", "Upload Error", errorDict)
                } else {
                    result.error("30011", "Upload result returning null values", null)
                }
            }} catch (e: Exception) {
            result.error("30012", "Upload exception", e.message)
        }
    }

    override fun setType(type: String?, result: MethodChannel.Result) {
        this.docType = type!!
        result.success(null)
    }

}