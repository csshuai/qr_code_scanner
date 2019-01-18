package net.touchcapture.qrcodescanner

import io.flutter.plugin.common.PluginRegistry.Registrar

class QrCodeScannerPlugin {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      registrar
        .platformViewRegistry()
        .registerViewFactory(
          "net.touchcapture.qrcodescanner/qrview", QRViewFactory(registrar)
        )
    }
  }
}
