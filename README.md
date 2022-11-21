# Amani low level SDK bindings for flutter
This repository contains flutter bindings for our [Android](https://github.com/AmaniTechnologiesLtd/Android_SDK_V2_Public) and [iOS](https://github.com/AmaniTechnologiesLtd/IOS_SDK_V2_Public) SDK's.

On the [example folder](#link-here) you can find a close to real world solution on how to use this SDK.

### Requirements
- iOS 11 or later (13 for NFC Capture)
- Android API 21 or later
- Flutter 3.0 or later

## Table of Contents
- [Installation](#installation)
    - [Android changes](#android-changes) 
    - [iOS changes](#ios-changes)
    - [iOS Permissions](#ios-permissions)
    - [Adding the flutter plugin](#adding-the-flutter-plugin)
- [Usage](#usage)
    - [ID Capture module](#idcapture-module)
    - [Selfie module](#selfie-module)
    - [Auto selfie module](#autoselfie-module)
    - [Pose estimation module](#pose-estimation-module)
    - [NFC Capture](#nfc-capture)
        - [NFC Capture on Android](#nfc-capture-on-android)
        - [NFC Capture on iOS](#nfc-capture-on-ios)
    - [Bio login](#bio-login)
## Installation
Before installing this SDK we must meet some requirements for your app to build with our native SDK's.

### Android changes
#### Adding the native Android SDK
On your apps `build.gradle` file, add our repository
```groovy
rootProject.allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url "https://jfrog.amani.ai/artifactory/amani-sdk" }
        jcenter()
    }
}
```

On the same file add our SDK to dependencies
```groovy
dependencies {
    implementation 'ai.amani.android:AmaniAi:2.1.50' // add this line
}
```

#### Changing main activity type

For this Flutter Plugin to work, you must change your MainActivity class to implement `FlutterFragmentActivity`. \
**This change is required otherwise you'll have runtime issues.**

Example MainActivity.kt
```kotlin
package ai.amani.flutter_amanisdk_v2_example

import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {
}
```

#### Update your AndroidManifest.xml

You must add `tools:replace="android:label"` on your main android manifest file.

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools" # this line must be added
    package="ai.amani.amanisdk_example">
	<application
        android:label="amanisdk_example"
        android:name="${applicationName}"
        tools:replace="android:label" #this line must be added
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            tools:replace="android:theme" 
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
```

### iOS changes

Add these lines on your pod file
```ruby
source "https://github.com/AmaniTechnologiesLtd/Mobile_SDK_Repo"
source "https://github.com/CocoaPods/Specs"
```

If not yet set the default iOS version to 11
```ruby
 platform :ios, '11.0'
 ```


### iOS permissions

You have to add these permissions into your `info.plist` file. All permissions are required for app submission.

For NFC:

```xml
    <key>com.apple.developer.nfc.readersession.iso7816.select-identifiers</key>
	<array>
		<string>A0000002471001</string>
	</array>
	<key>NFCReaderUsageDescription</key>
	<string>This application requires access to NFC to  scan IDs.</string>
```

For Location:

```xml
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>This application requires access to your location to upload the document.</string>
	<key>NSLocationUsageDescription</key>
	<string>This application requires access to your location to upload the document.</string>
	<key>NSLocationAlwaysUsageDescription</key>
	<string>This application requires access to your location to upload the document.</string>
	<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
	<string>This application requires access to your location to upload the document.</string>
```

For Camera:

```xml
	<key>NSCameraUsageDescription</key>
	<string>This application requires access to your camera for scanning and uploading the document.</string>
```

**Note**: You need to add all keys according to your usage.

#### **Grant access to NFC**

Enable the Near Field Communication Tag Reading capability in the target Signing & Capabilities.

#### Building for devices that don’t support NFC

For the devices that don’t support NFC (like iPhone 6), there is no CoreNFC library in the system and we are also using some iOS crypto libraries for reading NFC data supported after iOS 13. You need to add libraries below as optional under the Build Phases->Link Binary With Libraries menu. Even if you don't use the NFC process, you should add this libraries below.

```
CoreNFC.framework
CryptoKit.framework
CryptoTokenKit.framework
```

### Adding the flutter plugin 
To add this flutter plugin you must add the lines below to your `pubspec.yaml` file.

// MARK: Edit THIS after you got repo information
```yaml
amanisdk:
    git: https://github.com/AmaniTechnologiesLtd/Flutter_SDK_v2_Public
```

## Usage
Modules uses the same pattern of containing `start`, `setType` and `upload` methods. Each `start` method can have different parameters.

Before using any of the modules, you **must** initalize the SDK. This method needs to be called only **once** unless you have some other plugin that starts it's own activity.
```dart
final AmaniSDK _amaniSDK = AmaniSDK();

bool initSuccess = await AmaniSDK.initAmani(
          server: "https://server.example",
          customerToken: "customer_token",
          customerIdCardNumber: "customer_id_card_number",
          lang: "tr",
          useLocation: true,
          sharedSecret: "optional shared secret"  
).catchError((err) {
    // TODO: Handle the error.
})

if(initSuccess) {
    // Call the any of the modules
    IdCapture idCaptureModule = AmaniSDK.getIdCapture();
    idCaptureModule.setType("XXX_ID_0");
} else {
    throw Exception("Failed to initialize AmaniSDK");
}
```

### IDCapture module
Get the id capture module from the main `AmaniSDK` [instance which you have previously initialized.](#usage)

```dart
final AmaniSDK _amaniSDK = AmaniSDK();

// Since the platform plugins are async, you must create this function
Future<void> initSDK() async {
    var idCapture = _amaniSDK.getIdCapture();
    await idCapture.setType("XXX_ID_0");
}

//And call it here.
@override
void initState() {
    super.initState();
    initSDK();
}

```

Later on the buttons `onPressed` 
```dart
onPressed: () async {
            final Uint8List imageData =
                await _flutterAmanisdkV2Plugin.getIDCapture().start(IdSide.front);
            // Do something with imageData
            setState(() {
                _imageData = imageData;
            });
          },
```

After getting the image data from the SDK, you can use it with `Image.memory()`.

### Selfie Module
Get the selfie module from the main `AmaniSDK` [instance which you have previously initialized.](#usage)

```dart
final AmaniSDK _amaniSDK = AmaniSDK();

// Since the platform plugins are async, you must create this function
Future<void> initSelfie() async {
    var selfie = _amaniSDK.getSelfie();
    await selfie.setType("XXX_SE_0");
}

//And call it here.
@override
void initState() {
    super.initState();
    initSelfie();
}
```

Later on the buttons `onPressed` 
```dart
onPressed: () async {
            final Uint8List imageData =
                await _amaniSDK().getSelfie().start();
            // Do something with imageData
            setState(() {
                _imageData = imageData;
            });
          },
```

After getting the image data from the SDK, you can use it with `Image.memory()`.

### Auto selfie module

#### Changing the colors on Android
You must add a resource file on Android for AutoSelfie colors. You can find the keys in the example below.

To create this file, open the project on Android Studio right click on the `res` directory and create new Android Resource file. While creating select the "Resource Type" to values.

After that modify the file as shown below.
**note:** pose estimation module has different set of keys that you can add. If you want to use pose estimation while using the auto selfie merge the files.
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="auto_selfie_text">#000000</color>
    <color name="auto_selfie_counter_text">#000000</color>
    <color name="auto_selfie_oval_view">#000000</color>
    <color name="auto_selfie_success_anim">#000000</color>
</resources>
```

#### Auto selfie usage
Get the auto selfie module from the main `AmaniSDK` [instance which you have previously initialized.](#usage)
```dart
final AmaniSDK _amaniSDK = AmaniSDK();

// Configure the AutoSelfie
final IOSAutoSelfieSettings _iOSAutoSelfieSettings = IOSAutoSelfieSettings(
      faceIsOk: "Please hold stable",
      notInArea: "Please align your face with the area",
      faceTooSmall: "Your face is in too far",
      faceTooBig: "Your face is in too close",
      completed: "All OK!",
      appBackgroundColor: "000000",
      appFontColor: "ffffff",
      primaryButtonBackgroundColor: "ffffff",
      ovalBorderSuccessColor: "00ff00",
      ovalBorderColor: "ffffff",
      countTimer: "3",
      manualCropTimeout: 30);

final  AndroidAutoSelfieSettings _androidAutoSelfieSettings =
      AndroidAutoSelfieSettings(
          textSize: 16,
          counterVisible: true,
          counterTextSize: 21,
          manualCropTimeout: 30,
          distanceText: "Please align your face with the area",
          faceNotFoundText: "No faces found",
          restartText: "Process failed, restarting...",
          stableText: "Please hold stable");

// Since the platform plugins are async, you must create this function
Future<void> initAutoSelfie() async {
    var selfie = _amaniSDK.getAutoSelfie();
    await selfie.setType("XXX_SE_0");
}

//And call it here.
@override
void initState() {
    super.initState();
    initAutoSelfie();
}
```

Later on the buttons `onPressed` 
```dart
onPressed: () async {
            final Uint8List imageData =
                await _amaniSDK().getAutoSelfie().start(
                    iosAutoSelfieSettings: _iOSAutoSelfieSettings,
                    androidAutoSelfieSettings: _androidAutoSelfieSettings,
                );
            // Do something with imageData
            setState(() {
                _imageData = imageData;
            });
          },
```

### Pose estimation module

#### Changing the colors on Android
You must add a resource file on Android for AutoSelfie colors. You can find the keys in the example below.

To create this file, open the project on Android Studio right click on the `res` directory and create new Android Resource file. While creating select the "Resource Type" to values.

After that modify the file as shown below.
**note:** auto selfie module has different set of keys that you can add. If you want to use pose estimation while using the auto selfie merge the files.

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="pose_estimation_oval_view_start">#000000</color>
    <color name="pose_estimation_oval_view_success">#000000</color>
    <color name="pose_estimation_oval_view_error">#000000</color>
    <color name="pose_estimation_alert_title">#000000</color>
    <color name="pose_estimation_alert_description">#000000</color>
    <color name="pose_estimation_alert_try_again">#000000</color>
    <color name="pose_estimation_alert_background">#000000</color>
    <color name="pose_estimation_font">#000000</color>
</resources>
```

#### Pose estimation usage
Get the pose estimation module from the main `AmaniSDK` [instance which you have previously initialized.](#usage)
```dart
final AmaniSDK _amaniSDK = AmaniSDK();

// Configure the AutoSelfie
  final AndroidPoseEstimationSettings _androidPoseEstimationSettings =
      AndroidPoseEstimationSettings(
    poseCount: 3,
    animationDuration: 500,
    faceNotInsideMessage: "Your face is not inside the area",
    faceNotStraightMessage: "Your face is not straight",
    keepStraightMessage: "Please hold stable",
    alertTitle: "Verification Failed",
    alertDescription: "Failed 1",
    alertTryAgainMessage: "Try again",
  );

  final IOSPoseEstimationSettings _iosPoseEstimationSettings =
      IOSPoseEstimationSettings(
    faceIsOk: "Please hold stable",
    notInArea: "Please align your face to the area",
    faceTooSmall: "Your face is in too far",
    faceTooBig: "Your face is in too close",
    completed: "Verification Completed",
    turnedRight: "→",
    turnedLeft: "←",
    turnedUp: "↑",
    turnedDown: "↓",
    straightMessage: "Look straight",
    errorMessage: "Please complete the steps while your face is aligned to the area",
    tryAgain: "Try again",
    errorTitle: "Verification Failure",
    confirm: "Confirm",
    next: "Next",
    phonePitch: "Please hold the phone straight",
    informationScreenDesc1:
        "To start verification, align your face with the area",
    informationScreenDesc2: "",
    informationScreenTitle: "Selfie Verification Instructions",
    wrongPose: "Your face must be straight",
    descriptionHeader:
        "Please make sure you are doing the correct pose and your face is aligned with the area",
    appBackgroundColor: "000000",
    appFontColor: "ffffff",
    primaryButtonBackgroundColor: "ffffff",
    primaryButtonTextColor: "000000",
    ovalBorderColor: "ffffff",
    ovalBorderSuccessColor: "00ff00",
    poseCount: "3",
    showOnlyArrow: "true",
    buttonRadious: "10",
    manualCropTimeout: 30,
  );
// Since the platform plugins are async, you must create this function
Future<void> initPoseEstimation() async {
    var selfie = _amaniSDK.getPoseEstimation();
    await selfie.setType("XXX_SE_0");
}

//And call it here.
@override
void initState() {
    super.initState();
    initAutoSelfie();
}
```

Later on the buttons `onPressed` 
```dart
onPressed: () async {
            final Uint8List imageData =
                await _flutterAmanisdkV2Plugin
                  .getPoseEstimation()
                  .start(androidSettings: _androidPoseEstimationSettings, iosSettings: _iosPoseEstimationSettings);
            // Do something with imageData
            setState(() {
                _imageData = imageData;
            });
          },
```

### NFC capture
Due to differences in Android and iOS SDK's we had to seperate the NFC capture module. You must do a platform check and call the appropriate function.

#### NFC capture on Android
Android has single method for starting NFC Capture while there are multiple options to start the NFC Capture on iOS.


#### NFC capture on iOS
Native iOS SDK has different ways to start NFC Capture, but on the native Android you can only start with some fields that can found on the MRZ of the ID. 

Get the NFC module from the `AmaniSDK` class after you called the initAmani method with correct parameters. [See usage](#usage)

> **Note:** You can only run NFC capture on iOS 13.0 or later. If you want to compile your app for devices that runs iOS version before 13.0 check out [this section.](#building-for-devices-that-dont-support-nfc)

```dart
final _nfcModule = AmaniSDK().iOSNFC();
```

Starting with image of the back of the ID.
```dart
OutlinedButton(
    onPressed: () {
      _idCapture.start(IdSide.back).then((imageData) {
        _nfcCapture
            .startWithImageData(imageData)
            .then((isDone) => setState(() {
                  _isCompleted = isDone;
                }));
      });
    },
    child: const Text("Image Data Start")
)
```
// MARK: Correctness.
If you want to use the NFC data as NFC Document. Call the `setType` method with `XXX_NF_0` and run the methods from this module. 
**Anything related to IDCapture, including the NFC data must be called from the id capture.**

```dart
OutlinedButton(
    onPressed: () {
    // Does the same thing as above, 
      _nfcCapture.startWithMRZCapture().then((isCompleted) {
        setState(() {
          _isCompleted = isCompleted;
        });
      });
    },
    child: const Text("MRZ Capture Start")
)
```

You can also start this module with some data on the id itself.
```dart
OutlinedButton(
    onPressed: () {
      _nfcCapture.startWithMRZCapture().then((isCompleted) {
        setState(() {
          _isCompleted = isCompleted;
        });
      });
    },
    child: const Text("MRZ Capture Start")
)
```


**Note** type of image data is `Uint8List`.

#### Small note for ID Capture on iOS
ID Capture module has it's own NFC method on iOS for making things easier. To call it you must have captured the both front and back sides of the id since **capturing NFC data requires information can be extracted from the MRZ data.**

```dart
// After capturing the front and back side on the IdCapture
// Before calling upload
void iosStartNFCCapture() {
    if (Platform.isIOS) {
        _idCapture.startNFC().then((isNFCCaptureDone) {
            if (isNFCCaptureDone) {
                // nfc capture completed
                // You can safely proceed to upload.
            } else {
                startNFCCapture();
            }
        }).catchError((err) {
            // handle the error
        });
    }
}
```

### Bio login
This SDK also contains methods for biologin. You don't need to call `initAmani` method from the `AmaniSDK` class for running this.
