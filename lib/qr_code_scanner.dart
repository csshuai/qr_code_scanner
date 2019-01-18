import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void QRViewCreatedCallback(QRViewController controller);

enum DecodeMode {
  single,
  continuous,
}

class QRView extends StatefulWidget {
  const QRView({
    Key key,
    this.decodeMode = DecodeMode.single,
    this.onQRViewCreated,
  }) : super(key: key);

  final DecodeMode decodeMode;
  final QRViewCreatedCallback onQRViewCreated;

  @override
  State<StatefulWidget> createState() => _QRViewState();
}

class _QRViewState extends State<QRView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'net.touchcapture.qrcodescanner/qrview',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: _CreationParams.fromWidget(0, 0, widget).toMap(),
        creationParamsCodec: StandardMessageCodec(),
      );
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'net.touchcapture.qrcodescanner/qrview',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: _CreationParams.fromWidget(0, 0, widget).toMap(),
        creationParamsCodec: StandardMessageCodec(),
      );
    }

    return Text(
        '$defaultTargetPlatform is not yet supported by the qr_code_scanner plugin');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onQRViewCreated == null) {
      return;
    }
    widget.onQRViewCreated(new QRViewController._(id));
  }
}

class _CreationParams {
  _CreationParams({this.width, this.height, this.widget});

  static _CreationParams fromWidget(
      double width, double height, QRView widget) {
    return _CreationParams(
      width: width,
      height: height,
      widget: widget,
    );
  }

  final double width;
  final double height;
  final QRView widget;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'width': width,
      'height': height,
      'decodeMode': widget.decodeMode.index,
    };
  }
}

class QRViewController {
  QRViewController._(int id)
      : channel = MethodChannel('net.touchcapture.qrcodescanner/qrview_$id');
  final MethodChannel channel;

  Future<void> init(GlobalKey qrKey) async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final RenderBox renderBox = qrKey.currentContext.findRenderObject();
      return channel.invokeMethod("setDimensions",
          {"width": renderBox.size.width, "height": renderBox.size.height});
    }
  }
}
