package ai.amani.flutter_amanisdk.modules

import android.app.Activity
import io.flutter.plugin.common.MethodChannel.Result

interface Module {
    fun start(stepID: Int, activity: Activity, result: Result)
    fun upload(activity: Activity, result: Result)
    fun setType(type: String?, result: Result)
}