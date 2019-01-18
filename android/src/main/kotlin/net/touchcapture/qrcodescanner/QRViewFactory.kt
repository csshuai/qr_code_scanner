package net.touchcapture.qrcodescanner

import android.content.Context
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class QRViewFactory(private val registrar: PluginRegistry.Registrar) :
  PlatformViewFactory(StandardMessageCodec.INSTANCE) {

  override fun create(context: Context, id: Int, args: Any): PlatformView {
    val params = args as Map<String, Any>
    return QRView(context, registrar, id, params)
  }

}