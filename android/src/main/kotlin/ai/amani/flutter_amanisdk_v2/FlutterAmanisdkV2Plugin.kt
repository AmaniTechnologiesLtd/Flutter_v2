package ai.amani.flutter_amanisdk_v2

import ai.amani.flutter_amanisdk_v2.modules.*
import ai.amani.flutter_amanisdk_v2.modules.config_models.AutoSelfieSettings
import ai.amani.flutter_amanisdk_v2.modules.config_models.PoseEstimationSettings
import ai.amani.sdk.Amani
import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.JSONUtil
import io.flutter.plugin.common.PluginRegistry

/** FlutterAmanisdkV2Plugin */
class FlutterAmanisdkV2Plugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel

  // Give this reference to other modules e.g IdCapture when init.
  private var activity: Activity? = null


  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "amanisdk_method_channel")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

    when (call.method) {
      "initAmani" -> {
        val server = call.argument<String>("server")
        val customerIdCardNumber = call.argument<String>("customerIdCardNumber");
        val customerToken = call.argument<String>("customerToken")
        val lang = call.argument<String>("lang")
        val useLocation = call.argument<Boolean>("useLocation")
        val sharedSecret = call.argument<String?>("sharedSecret")

        initAmani(server!!, customerToken!!, customerIdCardNumber!!, lang!!, useLocation!!, sharedSecret, result)
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
      "uploadIDCapture" -> {
        val useLocation = call.argument<Boolean>("useLocation")
        IdCapture.instance.upload(useLocation!!, activity!!, result)
      }
      // Selfie
      "setSelfieType" -> {
        val type = call.argument<String>("type")
        IdCapture.instance.setType(type, result)
      }
      "startSelfie" -> {
        Selfie.instance.start(0, activity!!, result)
      }
      "uploadSelfie" -> {
        val useLocation = call.argument<Boolean>("useLocation")
        Selfie.instance.upload(useLocation!!, activity!!, result)
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
      "uploadAutoSelfie" -> {
        val useLocation = call.argument<Boolean>("useLocation")
        Selfie.instance.upload(useLocation!!, activity!!, result)
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
      "uploadPoseEstimation" -> {
        val useLocation = call.argument<Boolean>("useLocation")
        PoseEstimation.instance.upload(useLocation!!, activity!!, result)
      }
      else -> result.notImplemented()
    }

  }


  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    activity = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    if(NFC.instance.canStart()) {
      NFC.instance.bind(binding.activity as FlutterActivity)
      NFC.instance.enableNFCAdaptor(binding.activity as FlutterActivity)
    }
  }

  override fun onDetachedFromActivityForConfigChanges() {
      activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity

    // start the nfc adapter if can start NFC is true
    // FIXME: This won't work. Start a new activity.
    NFC.instance.enableNFCAdaptor(binding.activity as FlutterActivity)

    binding.addOnNewIntentListener { intent ->
      NFC.instance.onNewIntentHandler(intent)
      true
    }

  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  fun initAmani(server: String,
                customerToken: String,
                customerIdCardNumber: String,
                lang: String,
                useLocation: Boolean,
                sharedSecret: String?,
                result: Result) {
    if (activity != null) {
      Amani.init(activity, server, sharedSecret)
      Amani.sharedInstance().initAmani(activity!!, customerIdCardNumber, customerToken, useLocation, lang) { loggedIn, errorCode ->
        if (loggedIn) {
          result.success(loggedIn)
        } else {
          result.error(errorCode.toString(), "Api Error has occur while logging in", "check error code for details")
        }
      }
    } else {
      Log.e("AmaniSDK", "tried to init amani while activity is null")
    }
  }

}
