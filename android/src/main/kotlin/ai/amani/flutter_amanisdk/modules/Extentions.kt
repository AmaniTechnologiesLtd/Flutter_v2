package ai.amani.flutter_amanisdk.modules

import android.app.Activity
import android.widget.*
import androidx.annotation.DrawableRes
import androidx.core.content.ContextCompat
import com.google.gson.Gson

interface JSONConvertable {
    fun toJSON(): String = Gson().toJson(this)
}

inline fun <reified T: JSONConvertable> String.toObject(): T = Gson().fromJson(this, T::class.java)


fun Activity.logToast(message: String) {
    this.runOnUiThread {
        Toast.makeText(this.applicationContext, message, Toast.LENGTH_LONG).show()
    }
}

fun FrameLayout.setupBackButton(@DrawableRes drawable: Int, onClick: () -> Unit  ): Button {
    val buttonWidth = 90
    val buttonHeight = 90
    val padding = 40 
    var statusBarHeight = 0

    val button = Button(this.context)
    val params = LinearLayout.LayoutParams(buttonWidth, buttonHeight)

    val resourceId: Int = this.context.resources.getIdentifier("status_bar_height", "dimen", "android")
    if (resourceId > 0) {
        statusBarHeight = this.context.resources.getDimensionPixelSize(resourceId)
    }

    params.setMargins(
            this.resources.displayMetrics.widthPixels - (padding + buttonWidth),
            statusBarHeight + padding,
            padding + buttonWidth,
            0
    )

    button.layoutParams = params
    button.z = 99f

    button.background = ContextCompat.getDrawable(this.context, drawable)

    button.setOnClickListener {
        this.removeView(button)
        onClick.invoke()
    }

    this.addView(button)
    return button
}