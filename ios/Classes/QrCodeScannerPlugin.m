#import "QrCodeScannerPlugin.h"
#import <qr_code_scanner/qr_code_scanner-Swift.h>

@implementation QrCodeScannerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftQrCodeScannerPlugin registerWithRegistrar:registrar];
}
@end
