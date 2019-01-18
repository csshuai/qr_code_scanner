import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() => runApp(MaterialApp(home: MainPage()));

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainState();
  }
}

class _MainState extends State<MainPage> {
  String _qrText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner Home'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: _startScanner,
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: double.infinity),
        child: Text(
          "This is the result of scan: $_qrText",
        ),
      ),
    );
  }

  void _startScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return QRViewExample();
      }),
    ).then((value) {
      _qrText = value;
    }).catchError((error) {
      _qrText = '[$error]';
    });
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          AppBar(
            backgroundColor: Colors.transparent,
            title: Text('Scanner'),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    final channel = controller.channel;
    controller.init(qrKey);
    channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case "onRecognizeQR":
          dynamic arguments = call.arguments;
          print(arguments);
          Navigator.pop(context, arguments.toString());
      }
    });
  }
}
