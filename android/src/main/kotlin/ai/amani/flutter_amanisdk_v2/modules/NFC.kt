package ai.amani.flutter_amanisdk_v2.modules

import ai.amani.sdk.Amani
import android.annotation.SuppressLint
import android.app.Activity
import android.app.PendingIntent
import android.content.Intent
import android.graphics.Bitmap
import android.nfc.NfcAdapter
import androidx.fragment.app.FragmentActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodChannel

class NFC {
    private val NFCModule = Amani.sharedInstance().ScanNFC()
    private var docType: String = "XXX_NF_0"
    private var currentResult: MethodChannel.Result? = null
    private var nfcAdapter: NfcAdapter? = null

    private var activityRef: Activity? = null

    private var birthDate: String? = null
    private var expireDate: String? = null
    private var documentNo: String? = null

    companion object {
        val instance = NFC()
    }

    @SuppressLint("WrongConstant")
    fun start(birthDate: String, expireDate: String, documentNo: String, activity: Activity, channel: MethodChannel, result: MethodChannel.Result) {
        this.birthDate = birthDate
        this.expireDate = expireDate
        this.documentNo = documentNo
        this.activityRef = activity

        nfcAdapter = NfcAdapter.getDefaultAdapter(activity)
        if (nfcAdapter != null) {
            val intent = Intent(activity.applicationContext, this.javaClass)
            intent.flags = Intent.FLAG_ACTIVITY_SINGLE_TOP
            val pendingIntent = PendingIntent.getActivity(activity, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
            val filter = arrayOf(arrayOf("android.nfc.tech.IsoDep"))
            nfcAdapter!!.enableForegroundDispatch(activity, pendingIntent, null, filter)
            nfcAdapter!!.enableReaderMode(activity, {
                NFCModule.start(it, activity.applicationContext, birthDate, expireDate, documentNo) { _: Bitmap?, isSuccess: Boolean, exception: String? ->
                    if(isSuccess && exception == null) {
                        channel.invokeMethod("onNFCCompleted", mapOf("isSuccess" to isSuccess))
                    } else {
                        channel.invokeMethod("onError", mapOf("message" to exception!!))
                    }
                }
            }, NfcAdapter.FLAG_READER_NFC_A, null)
        }
        result.success(null)
    }

    fun disableNFC(activity: FlutterFragmentActivity) {
        nfcAdapter!!.disableReaderMode(activity)
    }

    fun setType(type: String, result: MethodChannel.Result) {
        docType = type
        result.success(null)
    }

    fun upload(result: MethodChannel.Result) {
        Amani.sharedInstance().ScanNFC().upload(activityRef as FragmentActivity, docType) { isSuccess, uploadRes, errors ->
           if (isSuccess && uploadRes == "OK") {
                result.success(true)
            } else if (!errors.isNullOrEmpty()) {
                result.error("1007", "Upload Error", errors[0].errorMessage)
            } else {
                result.success(false)
            }
        }
    }

}