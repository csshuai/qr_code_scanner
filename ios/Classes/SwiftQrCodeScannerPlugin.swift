import Flutter
import UIKit

public class SwiftQrCodeScannerPlugin: NSObject, FlutterPlugin {
    var factory: QRViewFactory
    public init(with registrar: FlutterPluginRegistrar) {
        self.factory = QRViewFactory(withRegistrar: registrar)
        registrar.register(factory, withId: "net.touchcapture.qrcodescanner/qrview")
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        registrar.addApplicationDelegate(SwiftQrCodeScannerPlugin(with: registrar))
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {

    }

    public func applicationWillTerminate(_ application: UIApplication) {

    }
}
