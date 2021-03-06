//
//  QRView.swift
//  flutter_qr
//
//  Created by Julius Canute on 21/12/18.
//

import Foundation
import MTBBarcodeScanner

public class QRView:NSObject,FlutterPlatformView {
    @IBOutlet var previewView: UIView!
    var decodeMode: Int64
    var scanner: MTBBarcodeScanner?
    var registrar: FlutterPluginRegistrar
    var channel: FlutterMethodChannel
    
    public init(withFrame frame: CGRect, withDecodeMode decodeMode: Int64, withRegistrar registrar: FlutterPluginRegistrar, withId id: Int64) {
        self.decodeMode = decodeMode
        self.registrar = registrar
        previewView = UIView(frame: frame)
        channel = FlutterMethodChannel(name: "net.touchcapture.qrcodescanner/qrview_\(id)", binaryMessenger: registrar.messenger())
    }
    
    func isCameraAvailable(success: Bool) -> Void {
        if success {
            do {
                try scanner?.startScanning(resultBlock: { codes in
                    if let codes = codes {
                        for code in codes {
                            let stringValue = code.stringValue!
                            self.channel.invokeMethod("onRecognizeQR", arguments: stringValue)
                            if self.decodeMode == 0 {
                                self.scanner?.stopScanning()
                            }
                        }
                    }
                })
            } catch {
                NSLog("Unable to start scanning")
            }
        } else {
            UIAlertView(title: "Scanning Unavailable", message: "This app does not have permission to access the camera", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok").show()
        }
    }
    
    public func view() -> UIView {
        channel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            guard call.method == "setDimensions" else {
                result(FlutterMethodNotImplemented)
                return
            }
            var arguments = call.arguments as! Dictionary<String, Double>
            self?.setDimensions(width: arguments["width"] ?? 0,height: arguments["height"] ?? 0, result: result)
        })
        return previewView
    }
    
    func setDimensions(width: Double, height: Double, result: FlutterResult) -> Void {
       previewView.frame = CGRect(x: 0, y: 0, width: width, height: height)
       scanner = MTBBarcodeScanner(previewView: previewView)
       MTBBarcodeScanner.requestCameraPermission(success: isCameraAvailable)
       result(nil)
    }
}
