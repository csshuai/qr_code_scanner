package net.touchcapture.qrcodescanner

import android.Manifest
import android.app.Activity
import android.app.Application
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.view.View
import com.google.zxing.ResultPoint
import com.journeyapps.barcodescanner.BarcodeCallback
import com.journeyapps.barcodescanner.BarcodeResult
import com.journeyapps.barcodescanner.BarcodeView
import com.journeyapps.barcodescanner.DefaultDecoderFactory
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.platform.PlatformView

class QRView(context: Context, private val registrar: PluginRegistry.Registrar, id: Int, params: Map<String, Any>) :
  PlatformView, MethodChannel.MethodCallHandler {

  companion object {
    const val CAMERA_REQUEST_ID = 513469796
  }

  var barcodeView = BarcodeView(context)
  private val activity = registrar.activity()
  private var channel: MethodChannel
  var cameraPermissionContinuation: Runnable? = null
  var requestingPermission = false

  init {
    registrar.addRequestPermissionsResultListener(CameraRequestPermissionsListener())

    channel = MethodChannel(registrar.messenger(), "net.touchcapture.qrcodescanner/qrview_$id")
    channel.setMethodCallHandler(this)

    startDecode(params)

    init()

    activity.application.registerActivityLifecycleCallbacks(
      object : Application.ActivityLifecycleCallbacks {
        override fun onActivityPaused(p0: Activity?) {
          barcodeView.pause()
        }

        override fun onActivityResumed(p0: Activity?) {
          init()
        }

        override fun onActivityStarted(p0: Activity?) {
        }

        override fun onActivityDestroyed(p0: Activity?) {
        }

        override fun onActivitySaveInstanceState(p0: Activity?, p1: Bundle?) {
        }

        override fun onActivityStopped(p0: Activity?) {
        }

        override fun onActivityCreated(p0: Activity?, p1: Bundle?) {
          barcodeView.decoderFactory = DefaultDecoderFactory()
        }

      })
  }

  private fun startDecode(params: Map<String, Any>) {
    if (params.containsKey("decodeMode")) {
      val decodeMode = params["decodeMode"] as Int?
      if (decodeMode == 0) {
        decodeSingle()
      } else {
        decodeContinuous()
      }
    } else {
      decodeContinuous()
    }
  }

  private fun decodeSingle() {
    barcodeView.decodeSingle(
      object : BarcodeCallback {
        override fun barcodeResult(result: BarcodeResult) {
          channel.invokeMethod("onRecognizeQR", result.text)
        }

        override fun possibleResultPoints(resultPoints: List<ResultPoint>) {}
      }
    )
  }

  private fun decodeContinuous() {
    barcodeView.decodeContinuous(
      object : BarcodeCallback {
        override fun barcodeResult(result: BarcodeResult) {
          channel.invokeMethod("onRecognizeQR", result.text)
        }

        override fun possibleResultPoints(resultPoints: List<ResultPoint>) {}
      }
    )
  }

  private fun init() {
    if (!hasCameraPermission()) {
      checkAndRequestPermission(null)
    } else {
      barcodeView.resume()
    }
  }

  override fun getView(): View {
    return barcodeView
  }

  override fun dispose() {
    barcodeView.pause()
  }

  private inner class CameraRequestPermissionsListener : PluginRegistry.RequestPermissionsResultListener {
    override fun onRequestPermissionsResult(id: Int, permissions: Array<String>, grantResults: IntArray): Boolean {
      if (id == CAMERA_REQUEST_ID) {
        cameraPermissionContinuation?.run()
        return true
      }
      return false
    }
  }

  private fun hasCameraPermission(): Boolean {
    return Build.VERSION.SDK_INT < Build.VERSION_CODES.M ||
        activity.checkSelfPermission(Manifest.permission.CAMERA) === PackageManager.PERMISSION_GRANTED
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "checkAndRequestPermission" -> {
        checkAndRequestPermission(result)
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  private fun checkAndRequestPermission(result: MethodChannel.Result?) {
    if (cameraPermissionContinuation != null) {
      result?.error("cameraPermission", "Camera permission request ongoing", null)
    }

    cameraPermissionContinuation = Runnable {
      cameraPermissionContinuation = null
      if (!hasCameraPermission()) {
        result?.error(
          "cameraPermission", "MediaRecorderCamera permission not granted", null
        )
        return@Runnable
      }
    }

    requestingPermission = false
    if (hasCameraPermission()) {
      cameraPermissionContinuation?.run()
    } else {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        requestingPermission = true
        registrar
          .activity()
          .requestPermissions(
            arrayOf(Manifest.permission.CAMERA),
            CAMERA_REQUEST_ID
          )
      }
    }
  }

}