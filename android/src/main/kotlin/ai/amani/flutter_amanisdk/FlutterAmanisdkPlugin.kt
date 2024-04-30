package ai.amani.flutter_amanisdk

import ai.amani.base.utility.AmaniVersion
import ai.amani.flutter_amanisdk.modules.*
import ai.amani.flutter_amanisdk.modules.config_models.AutoSelfieSettings
import ai.amani.flutter_amanisdk.modules.config_models.PoseEstimationSettings
import ai.amani.sdk.Amani
import ai.amani.sdk.UploadSource
import ai.amani.sdk.interfaces.AmaniEventCallBack
import ai.amani.sdk.model.amani_events.error.AmaniError
import ai.amani.sdk.model.amani_events.profile_status.ProfileStatus
import ai.amani.sdk.model.amani_events.steps_result.StepsResult
import ai.amani.sdk.model.customer.CustomerDetailResult
import ai.amani.sdk.modules.customer.detail.CustomerDetailObserver
import android.app.Activity
import com.google.gson.Gson
import io.flutter.Log
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** FlutterAmanisdkPlugin */
class FlutterAmanisdkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel
  private lateinit var nfcChannel: MethodChannel
  private lateinit var bioLoginChannel: MethodChannel
  private lateinit var delegateChannel: EventChannel
  // Give this reference to other modules e.g IdCapture when init.
  private var activity: Activity? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "amanisdk_method_channel")
    channel.setMethodCallHandler(this)

    // Channels below is created due to usage of the different call handlers of different classes on
    // dart side
    nfcChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "amanisdk_nfc_channel")
    bioLoginChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "amanisdk_biologin_channel")
    // Event channel goes brr
    delegateChannel = EventChannel(flutterPluginBinding.binaryMessenger, "amanisdk_delegate_channel")
    delegateChannel.setStreamHandler(AmaniDelegateEventHandler())
  }

  override fun onMethodCall(call: MethodCall, result: Result) {

    when (call.method) {
      "initAmani" -> {
        val server = call.argument<String>("server")!!
        val customerIdCardNumber = call.argument<String>("customerIdCardNumber")!!
        val customerToken = call.argument<String>("customerToken")!!
        val lang = call.argument<String>("lang")!!
        val useLocation = call.argument<Boolean>("useLocation")!!
        val sharedSecret = call.argument<String>("sharedSecret")
        val version = call.argument<String>("apiVersion") ?: "v2" // Default to v2

        activity?.runOnUiThread {
          initAmani(server, customerToken, customerIdCardNumber, lang, useLocation, sharedSecret, version, result)
        }
      }
      "initAmaniWithEmail" -> {
        val server = call.argument<String>("server")!!
        val customerIdCardNumber = call.argument<String>("customerIdCardNumber")!!
        val email = call.argument<String>("email")!!
        val password = call.argument<String>("password")!!
        val lang = call.argument<String>("lang")!!
        val useLocation = call.argument<Boolean>("useLocation")!!
        val sharedSecret = call.argument<String>("sharedSecret")
        val version = call.argument<String>("apiVersion") ?: "v2" // Default to v2

        activity!!.runOnUiThread {
          initAmaniWithEmail(server, customerIdCardNumber, email, password, lang, useLocation, sharedSecret, version, result)
        }
      }
      // IdCapture
      "setIDCaptureType" -> {
        val type = call.argument<String>("type")
        IdCapture.instance.setType(type, result)
      }
      "startIDCapture" -> {
        val stepID = call.argument<Int>("stepID")
        if (stepID != null) {
          IdCapture.instance.start(stepID, activity!!, result)
        } else {
          IdCapture.instance.start(0, activity!!, result)
        }
      }
      "setIDCaptureManualButtonTimeout" -> {
        val timeout = call.argument<Int>("timeout")!!
        IdCapture.instance.setManualCaptureButtonTimeout(timeout)
        result.success(true)
      }
      "setIDCaptureNFC" -> {
        val usesNFC = call.argument<Boolean>("usesNFC")!!
        IdCapture.instance.setWithNFC(usesNFC)
        result.success(true)
      }
      "setIDCaptureVideoRecordingEnabled" -> {
        val isEnabled = call.argument<Boolean>("enabled") ?: false
        IdCapture.instance.setVideoRecording(isEnabled, result)
      }
      "setIDCaptureHologramDetection" -> {
        val isEnabled = call.argument<Boolean>("enabled") ?: false
        IdCapture.instance.setHologramDetection(isEnabled, result)
      }
      "uploadIDCapture" -> {
        IdCapture.instance.upload(activity!!, result)
      }
      "idCaptureAndroidBackPressHandle" -> {
        IdCapture.instance.backPressHandle(activity!!, result)
      }
      // Selfie
      "setSelfieType" -> {
        val type = call.argument<String>("type")
        IdCapture.instance.setType(type, result)
      }
      "startSelfie" -> {
        Selfie.instance.start(0, activity!!, result)
      }
      "selfieAndroidBackPressHandle" -> {
        Selfie.instance.backPressHandle(activity!!, result)
      }
      "uploadSelfie" -> {
        Selfie.instance.upload( activity!!, result)
      }
      // AutoSelfie
      "startAutoSelfie" -> {
        val androidSettings = call.argument<String>("androidSettings")
        if (androidSettings != null) {
          val model = androidSettings.toObject<AutoSelfieSettings>()
          AutoSelfie.instance.setSettings(model)
          AutoSelfie.instance.start(0, activity!!, result)
        } else result.error("Missing Settings", "You must give all the parameters", null)
      }
      "setAutoSelfieType" -> {
        val type = call.argument<String>("type")
        AutoSelfie.instance.setType(type, result)
      }
      "autoSelfieAndroidBackPressHandle" -> {
        AutoSelfie.instance.backPressHandle(activity!!, result)
      }
      "uploadAutoSelfie" -> {
       AutoSelfie.instance.upload(activity!!, result)
      }
      // Pose Estimation
      "startPoseEstimation" -> {
        val androidSettings = call.argument<String>("androidSettings")
        if (androidSettings != null) {
          val model = androidSettings.toObject<PoseEstimationSettings>()
          PoseEstimation.instance.setSettings(model)
          PoseEstimation.instance.start(0, activity!!, result)
        } else result.error("Missing Settings", "You must give all the parameters", null)
      }
      "setPoseEstimationType" -> {
        val type = call.argument<String>("type")
        PoseEstimation.instance.setType(type, result)
      }
      "poseEstimationAndroidBackPressHandle" -> {
        PoseEstimation.instance.backPressHandle(activity!!, result)
      }
      "uploadPoseEstimation" -> {
        PoseEstimation.instance.upload(activity!!, result)
      }
      "setPoseEstimationVideoRecording" -> {
        val isEnabled = call.argument<Boolean>("enabled") ?: false
        PoseEstimation.instance.setVideoRecording(isEnabled, result)
      }
      // NFC
      "androidStartNFC" -> {
        val birthDate = call.argument<String>("birthDate")
        val expireDate = call.argument<String>("expireDate")
        val documentNo = call.argument<String>("documentNo")
        if (!IdCapture.instance.usesNFC) {
          if (birthDate == null || expireDate == null || documentNo == null) {
            result.error("Missing Params", "If you are using this module to capture nfc as a document.", null)
            return
          }
        }

        NFC.instance.start(birthDate, expireDate, documentNo, activity!!, nfcChannel, result)
      }
      "androidDisableNFC" -> {
        NFC.instance.disableNFC(activity as FlutterFragmentActivity)
        result.success(null)
      }
      "androidSetNFCType" -> {
        val type = call.argument<String>("type")
        if (type != null) {
          NFC.instance.setType(type, result)
        }
      }
      "androidUploadNFC" -> {
        NFC.instance.upload(result)
      }
      "initBioLogin" -> {
        val server = call.argument<String>("server")!!
        val sharedSecret = call.argument<String>("sharedSecret")
        val token = call.argument<String>("token")!!
        val customerId = call.argument<String>("customerId")
        val attemptId = call.argument<String>("attemptId")
        val source = call.argument<Int>("source")
        val comparisonAdapter = call.argument<Int>("comparisonAdapter")

        BioLogin.instance.initBioLogin(server, sharedSecret, token, customerId!!.toInt(), comparisonAdapter, source, attemptId!!,  activity!!, result)
      }
      "startBioLoginWithAutoSelfie" -> {
        val androidSettings = call.argument<String>("androidSettings")
        if (androidSettings != null) {
          val model = androidSettings.toObject<AutoSelfieSettings>()
          BioLogin.instance.startWithAutoSelfie(model, activity!!, result)
        } else result.error("Missing Settings", "You must give all the parameters", null)
      }
      "androidStartBioLoginWithPoseEstimation" -> {
        val androidSettings = call.argument<String>("androidSettings")
        if(androidSettings != null) {
          val model = androidSettings.toObject<PoseEstimationSettings>()
          BioLogin.instance.startWithPoseEstimation(model, activity!!, result, bioLoginChannel)
        } else result.error("Missing Settings", "You must give all the parameters", null)
      }
      "startBioLoginWithManualSelfie" -> {
        val selfieDescriptionText = call.argument<String>("androidSelfieDescriptionText")!!
        BioLogin.instance.startWithManualSelfie(selfieDescriptionText, activity!!, result)
      }
      "bioLoginAndroidBackPressHandle" -> {
        BioLogin.instance.backPressHandle(activity!!, result)
      }
      "uploadBioLogin" -> {
        BioLogin.instance.upload(result)
      }
      "getCustomerInfo" -> {
        getCustomerInfo(result)
      }
      "startDocumentCapture" -> {
        val docCountParam = call.argument<Int>("documentCount") ?: 1
        DocumentCapture.instance.start(docCountParam, activity!!, result)
      }
      "setDocumentCaptureType" -> {
        val type = call.argument<String>("type")
        DocumentCapture.instance.setType(type, result)
      }
      "documentCaptureUpload" -> {
        val files = call.argument<List<Map<String, Any>>>("files")
        if (files != null) {
          DocumentCapture.instance.setFiles(files)
        }
          DocumentCapture.instance.upload(activity!!, result)
      }
      "documentCaptureBackPressHandle" -> {
        DocumentCapture.instance.backPressHandle(activity!!, result)
      }
      else -> result.notImplemented()
    }
  }


  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    activity = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
      activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  private fun initAmani(server: String,
                customerToken: String,
                customerIdCardNumber: String,
                lang: String,
                useLocation: Boolean,
                sharedSecret: String?,
                version: String,
                result: Result) {
    if (activity != null) {
      activity!!.runOnUiThread {
        val amaniVersion = if (version == "v2") AmaniVersion.V2 else AmaniVersion.V1
        Amani.init(activity, server, sharedSecret, amaniVersion, UploadSource.KYC)
        android.util.Log.d("TAG", "initAmani: $version")
        Amani.sharedInstance().initAmani(
          activity!!,
          customerIdCardNumber,
          customerToken,
          useLocation,
          lang
        ) { loggedIn ->
          result.success(loggedIn)
        }
      }
    } else {
      Log.e("AmaniSDK", "tried to init amani while activity is null")
      result.error("30020", "Activity is null", null)
    }
  }

  private fun initAmaniWithEmail(server: String,
                        customerIdCardNumber: String,
                        email: String,
                        password: String,
                        lang: String,
                        useLocation: Boolean,
                        sharedSecret: String?,
                        version: String,
                        result: Result) {
    if (activity != null) {
      activity!!.runOnUiThread {
        val amaniVersion = if (version == "v2") AmaniVersion.V2 else AmaniVersion.V1
        Amani.init(activity, server, sharedSecret, amaniVersion, UploadSource.KYC)
        Amani.sharedInstance().initAmani(activity!!, customerIdCardNumber, email, password, useLocation, lang) { loggedIn ->
          result.success(loggedIn)
        }
      }
    } else {
      Log.e("AmaniSDK", "tried to init amani while activity is null")
      result.error("30020", "Activity is null", null)
    }
  }

  private fun getCustomerInfo(result: Result) {
    Amani.sharedInstance().CustomerDetail().getCustomerDetail(object : CustomerDetailObserver {
      override fun result(customerDetail: CustomerDetailResult?, throwable: Throwable?) {
        if (throwable != null) {
          result.error("CustomerInfo-Fetch", throwable.message, null)
        } else if (customerDetail != null) {

          val rules = customerDetail.rules?.map {
              mapOf(
                      "id" to (it.id as Any),
                      "title" to (it.title as Any),
                      "documentClasses" to (it.documentClasses as Any),
                      "status" to (it.status as Any),
              )
          }

          val missingRules = customerDetail.missingRules?.map {
            mapOf(
                    "id" to (it?.id as Any),
                    "title" to (it.title as Any),
                    "documentClasses" to (it.documentClasses as Any),
            )
          }

          val customerInfoDict = mapOf(
                  "id" to customerDetail.id,
                  "name" to customerDetail.name,
                  "email" to customerDetail.email,
                  "phone" to customerDetail.phone,
                  "status" to customerDetail.status,
                  "occupation" to customerDetail.occupation,
                  // FIXME: v3 address changes
                  "city" to null,
                  "address" to null,
                  "province" to null,
//                  "city" to if(customerDetail.address != null) customerDetail.address.city else null,
//                  "address" to if(customerDetail.address != null) customerDetail.address.address else null,
//                  "province" to if(customerDetail.address != null) customerDetail.address.province else null,
                  "idCardNumber" to customerDetail.idCardNumber,
                  "rules" to rules,
                  "missingRules" to missingRules,
          )

          result.success(customerInfoDict)
        }
      }
    })
  }
}
