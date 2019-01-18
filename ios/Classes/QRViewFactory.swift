//
//  QRViewFactory.swift
//  flutter_qr
//
//  Created by Julius Canute on 21/12/18.
//

import Foundation

public class QRViewFactory: NSObject, FlutterPlatformViewFactory {
    
    var registrar: FlutterPluginRegistrar?
    
    public init(withRegistrar registrar: FlutterPluginRegistrar){
        super.init()
        self.registrar = registrar
    }
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        var dictionary = args as! Dictionary<String, Any>
        let width = dictionary["width"] as? Double ?? 0
        let height = dictionary["height"] as? Double ?? 0
        let decodeMode = dictionary["decodeMode"] as? Int64 ?? 0
        return QRView(withFrame: CGRect(x: 0, y: 0, width: width, height: height), withDecodeMode: decodeMode, withRegistrar: registrar!,withId: viewId)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec(readerWriter: FlutterStandardReaderWriter())
    }
}
