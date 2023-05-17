package ai.amani.flutter_amanisdk_v2.modules

import ai.amani.sdk.Amani
import android.annotation.SuppressLint
import android.app.Activity
import android.app.PendingIntent
import android.content.Intent
import android.graphics.Bitmap
import android.nfc.NfcAdapter
import android.os.Build
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

    private val FLAG_MUTABLE = 1 shl 25
    private val VERSION_CODES_S = 31

    companion object {
        val instance = NFC()
    }

    @SuppressLint("WrongConstant")
    fun start(birthDate: String?, expireDate: String?, documentNo: String?, activity: Activity, channel: MethodChannel, result: MethodChannel.Result) {
        if (IdCapture.instance.usesNFC) {
            IdCapture.instance.getMRZ(
                    onComplete = {
                        this.birthDate = it.mRZBirthDate
                        this.expireDate = it.mRZExpiryDate
                        this.documentNo = it.mRZDocumentNumber
                        this.activityRef = activity
                        startNFC(activity, result, channel)
                    },
                    onError = {
                        result.error(it.errorCode.toString(), it.errorMessage, null)
                    }
            )
        } else {
            this.birthDate = birthDate
            this.expireDate = expireDate
            this.documentNo = documentNo
            this.activityRef = activity
            startNFC(activity, result, channel)
        }
    }

    // Suppressed lint as we support compiler 33 and we're checking the version code
    @SuppressLint("WrongConstant")
    private fun startNFC(activity: Activity, result: MethodChannel.Result, channel: MethodChannel) {
        nfcAdapter = NfcAdapter.getDefaultAdapter(activity)
        if (nfcAdapter != null) {
            val intent = Intent(activity.applicationContext, this.javaClass)
            intent.flags = Intent.FLAG_ACTIVITY_SINGLE_TOP
            val pendingIntent = if (Build.VERSION.SDK_INT >= VERSION_CODES_S) {
                PendingIntent.getActivity(activity, 0, Intent(activity, javaClass)
                        .addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP), FLAG_MUTABLE)
            } else{
                PendingIntent.getActivity(activity, 0, Intent(activity, javaClass)
                        .addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP), 0)
            }
            val filter = arrayOf(arrayOf("android.nfc.tech.IsoDep"))
            nfcAdapter!!.enableForegroundDispatch(activity, pendingIntent, null, filter)
            nfcAdapter!!.enableReaderMode(activity, {
                activity.runOnUiThread {
                    channel.invokeMethod("onScanStart", mapOf("started" to true))
                }
                NFCModule.start(it, activity.applicationContext, birthDate, expireDate, documentNo) { _: Bitmap?, isSuccess: Boolean, exception: String? ->
                    if(isSuccess && exception == null) {
                        channel.invokeMethod("onNFCCompleted", mapOf("isSuccess" to isSuccess))
                    } else {
                        channel.invokeMethod("onError", mapOf("message" to exception!!))
                    }
                }
            }, NfcAdapter.FLAG_READER_NFC_A, null)

            result.success(true)
        } else {
            result.error("1458", "Failed to get default nfc adapter", null)
        }
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