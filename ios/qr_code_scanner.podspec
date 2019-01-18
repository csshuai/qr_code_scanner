#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'qr_code_scanner'
  s.version          = '0.0.1'
  s.summary          = 'QR code scanner that can be embedded inside flutter. It uses zxing in Android and MTBBarcode scanner in iOS.'
  s.description      = <<-DESC
QR code scanner that can be embedded inside flutter. It uses zxing in Android and MTBBarcode scanner in iOS.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'MTBBarcodeScanner'

  s.ios.deployment_target = '8.0'
end

