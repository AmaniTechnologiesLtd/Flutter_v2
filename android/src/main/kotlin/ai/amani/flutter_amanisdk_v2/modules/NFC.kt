package ai.amani.flutter_amanisdk_v2.modules

import ai.amani.sdk.Amani
import android.annotation.SuppressLint
import android.app.Activity
import android.app.PendingIntent
import android.content.Intent
import android.graphics.Bitmap
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class NFC {
    private val NFCModule = Amani.sharedInstance().ScanNFC()
    private val docType: String = "XXX_NF_0"
    private var currentResult: MethodChannel.Result? = null
    private var nfcAdapter: NfcAdapter? = null
    private val FLAG_MUTABLE = 1 shl 25
    private val VERSION_CODES_S = 31

    private var activityRef: FlutterActivity? = null

    private var birthDate: String? = null
    private var expireDate: String? = null
    private var documentNo: String? = null

    companion object {
        val instance = NFC()
    }

    fun canStart(): Boolean {
        return birthDate != null && expireDate != null && documentNo != null && currentResult != null
    }

    fun start(birthDate: String, expireDate: String, documentNo: String, result: MethodChannel.Result) {
        this.birthDate = birthDate
        this.expireDate = expireDate
        this.documentNo = documentNo
        currentResult = result
    }

    fun bind(activity: FlutterActivity) {
        activityRef = activity
    }

    fun onNewIntentHandler(intent: Intent) {
        if (!canStart()) { return }
        val tag = intent.extras!!.getParcelable<Tag>(NfcAdapter.EXTRA_TAG)
        Amani.sharedInstance().ScanNFC().start(tag, activityRef!!.applicationContext,
                birthDate!!,
                expireDate!!,
                documentNo!!) { _: Bitmap, isSuccess: Boolean, exception: String? ->
                if (isSuccess) {
                    currentResult!!.success(true)
                } else if (exception != null) {
                    currentResult!!.error("NFCReadError", exception, null)
                }
        }
    }

    @SuppressLint("WrongConstant")
    fun enableNFCAdaptor(activity: FlutterActivity) {
        if (nfcAdapter != null) { return }
        nfcAdapter = NfcAdapter.getDefaultAdapter(activity)
        if (nfcAdapter != null) {

            val pendingIntent = if (Build.VERSION.SDK_INT >= VERSION_CODES_S) {
                PendingIntent.getActivity(activity, 0, Intent(activity, javaClass)
                        .addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP), FLAG_MUTABLE)
            } else{
                PendingIntent.getActivity(activity, 0, Intent(activity, javaClass)
                        .addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP), 0)
            }

            val filter = arrayOf(arrayOf("android.nfc.tech.IsoDep"))
            nfcAdapter!!.enableForegroundDispatch(activity, pendingIntent, null, filter)
        }

    }

}